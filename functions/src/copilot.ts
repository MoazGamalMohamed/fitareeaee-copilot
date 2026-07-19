import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";
import OpenAI from "openai";

const MODEL = "gpt-5.6";
const MAX_INPUT_LENGTH = 1200;
const MAX_CALLS_PER_HOUR = 12;
const MIN_INTERVAL_MS = 8_000;
const draftKeys = new Set([
  "schemaVersion", "intent", "tripType", "origin", "destination",
  "departureDate", "departureTime", "passengerOrSeatCount", "packageDetails",
  "maximumBudget", "preferences", "assistantSummary", "missingInformation",
  "clarificationQuestion", "language",
]);

export interface CopilotDraft {
  schemaVersion: 1;
  intent: "find" | "offer";
  tripType: "ride" | "package";
  origin: string | null;
  destination: string | null;
  departureDate: string | null;
  departureTime: string | null;
  passengerOrSeatCount: number | null;
  packageDetails: string | null;
  maximumBudget: number | null;
  preferences: string[];
  assistantSummary: string;
  missingInformation: string[];
  clarificationQuestion: string | null;
  language: "en" | "ar";
}

const draftSchema = {
  type: "object",
  additionalProperties: false,
  required: [
    "schemaVersion",
    "intent",
    "tripType",
    "origin",
    "destination",
    "departureDate",
    "departureTime",
    "passengerOrSeatCount",
    "packageDetails",
    "maximumBudget",
    "preferences",
    "assistantSummary",
    "missingInformation",
    "clarificationQuestion",
    "language",
  ],
  properties: {
    schemaVersion: {type: "integer", enum: [1]},
    intent: {type: "string", enum: ["find", "offer"]},
    tripType: {type: "string", enum: ["ride", "package"]},
    origin: {type: ["string", "null"]},
    destination: {type: ["string", "null"]},
    departureDate: {type: ["string", "null"]},
    departureTime: {type: ["string", "null"]},
    passengerOrSeatCount: {type: ["integer", "null"], minimum: 1, maximum: 8},
    packageDetails: {type: ["string", "null"]},
    maximumBudget: {type: ["number", "null"], minimum: 0, maximum: 100000},
    preferences: {type: "array", maxItems: 12, items: {type: "string"}},
    assistantSummary: {type: "string"},
    missingInformation: {type: "array", maxItems: 12, items: {type: "string"}},
    clarificationQuestion: {type: ["string", "null"]},
    language: {type: "string", enum: ["en", "ar"]},
  },
} as const;

function object(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new functions.https.HttpsError("invalid-argument", "A request is required.");
  }
  return value as Record<string, unknown>;
}

export function parsePlanRequest(value: unknown): {
  request: string;
  locale: "en" | "ar";
  timezone: string;
} {
  const data = object(value);
  const request = typeof data.request === "string" ? data.request.trim() : "";
  if (request.length < 5 || request.length > MAX_INPUT_LENGTH) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      `Describe the trip in 5 to ${MAX_INPUT_LENGTH} characters.`
    );
  }
  const locale = data.locale === "ar" ? "ar" : "en";
  const timezone = typeof data.timezone === "string" &&
    /^[A-Za-z0-9_+\-/:]{1,64}$/.test(data.timezone) ? data.timezone : "UTC";
  return {request, locale, timezone};
}

export function authenticatedUid(auth: {uid?: unknown} | null | undefined): string {
  if (!auth || typeof auth.uid !== "string" || !auth.uid) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Sign in to use Plan with AI."
    );
  }
  return auth.uid;
}

export function redactContactDetails(value: string): string {
  const dates: string[] = [];
  const protectedValue = value.replace(/[\p{Nd}]{4}-[\p{Nd}]{2}-[\p{Nd}]{2}/gu, (date) => {
    dates.push(date);
    return `__PRESERVED_DATE_${dates.length - 1}__`;
  });
  return protectedValue
    .replace(/https?:\/\/\S+/gi, "[url removed]")
    .replace(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi, "[email removed]")
    .replace(/(?:[+\p{Nd}][\p{Nd}\s().-]{6,}\p{Nd})/gu, (match) => {
      const digits = match.match(/\p{Nd}/gu) ?? [];
      return digits.length >= 7 ? "[number removed]" : match;
    })
    .replace(/__PRESERVED_DATE_(\d+)__/g, (_match, index) => dates[Number(index)] ?? "[date]");
}

function nullableString(value: unknown, field: string, max = 240): string | null {
  if (value === null) return null;
  if (typeof value !== "string") throw new Error(`${field} must be a string or null`);
  const normalized = value.trim();
  if (!normalized || normalized.length > max) throw new Error(`${field} is invalid`);
  return normalized;
}

function stringArray(value: unknown, field: string): string[] {
  if (!Array.isArray(value) || value.length > 12) throw new Error(`${field} is invalid`);
  return value.map((item) => {
    if (typeof item !== "string") throw new Error(`${field} is invalid`);
    const normalized = item.trim();
    if (!normalized || normalized.length > 120) throw new Error(`${field} is invalid`);
    return normalized;
  });
}

export function validateDraft(value: unknown): CopilotDraft {
  const data = object(value);
  if (Object.keys(data).some((key) => !draftKeys.has(key))) {
    throw new Error("Draft contains unknown fields");
  }
  if (data.schemaVersion !== 1) throw new Error("Unsupported draft version");
  if (data.intent !== "find" && data.intent !== "offer") throw new Error("Invalid intent");
  if (data.tripType !== "ride" && data.tripType !== "package") throw new Error("Invalid trip type");
  if (data.language !== "en" && data.language !== "ar") throw new Error("Invalid language");

  const departureDate = nullableString(data.departureDate, "departureDate", 10);
  if (departureDate !== null && !/^\d{4}-\d{2}-\d{2}$/.test(departureDate)) {
    throw new Error("Invalid departure date");
  }
  if (departureDate !== null) {
    const [year, month, day] = departureDate.split("-").map(Number);
    const parsed = new Date(Date.UTC(year, month - 1, day));
    if (
      parsed.getUTCFullYear() !== year ||
      parsed.getUTCMonth() !== month - 1 ||
      parsed.getUTCDate() !== day
    ) {
      throw new Error("Invalid departure date");
    }
  }
  const departureTime = nullableString(data.departureTime, "departureTime", 5);
  if (departureTime !== null && !/^(?:[01]\d|2[0-3]):[0-5]\d$/.test(departureTime)) {
    throw new Error("Invalid departure time");
  }
  const count = data.passengerOrSeatCount;
  if (count !== null && (!Number.isInteger(count) || (count as number) < 1 || (count as number) > 8)) {
    throw new Error("Invalid passenger or seat count");
  }
  const budget = data.maximumBudget;
  if (budget !== null && (typeof budget !== "number" || !Number.isFinite(budget) || budget < 0 || budget > 100000)) {
    throw new Error("Invalid maximum budget");
  }
  const assistantSummary = nullableString(
    data.assistantSummary,
    "assistantSummary",
    500
  );
  if (assistantSummary === null) {
    throw new Error("Missing assistant summary");
  }

  return {
    schemaVersion: 1,
    intent: data.intent,
    tripType: data.tripType,
    origin: nullableString(data.origin, "origin"),
    destination: nullableString(data.destination, "destination"),
    departureDate,
    departureTime,
    passengerOrSeatCount: count as number | null,
    packageDetails: nullableString(data.packageDetails, "packageDetails", 500),
    maximumBudget: budget as number | null,
    preferences: stringArray(data.preferences, "preferences"),
    assistantSummary,
    missingInformation: stringArray(data.missingInformation, "missingInformation"),
    clarificationQuestion: nullableString(data.clarificationQuestion, "clarificationQuestion", 300),
    language: data.language,
  };
}

export function nextRateLimitState({
  nowMs,
  lastRequestMs,
  windowStartedMs,
  count,
}: {
  nowMs: number;
  lastRequestMs: number;
  windowStartedMs: number;
  count: number;
}): {windowStartedMs: number; count: number} {
  if (nowMs - lastRequestMs < MIN_INTERVAL_MS) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      "Wait a few seconds before trying again."
    );
  }
  const inWindow = nowMs - windowStartedMs < 60 * 60 * 1000;
  if (inWindow && count >= MAX_CALLS_PER_HOUR) {
    throw new functions.https.HttpsError(
      "resource-exhausted",
      "Hourly AI planning limit reached."
    );
  }
  return {
    windowStartedMs: inWindow ? windowStartedMs : nowMs,
    count: (inWindow ? count : 0) + 1,
  };
}

export function safeOpenAIErrorMetadata(error: unknown): {
  errorName: string;
  status?: number;
  code?: string;
  type?: string;
} {
  const record = error !== null && typeof error === "object" ?
    error as Record<string, unknown> : {};
  const safeToken = (value: unknown): string | undefined =>
    typeof value === "string" && /^[A-Za-z0-9_.-]{1,80}$/.test(value) ? value : undefined;
  const errorName = error instanceof Error ?
    safeToken(error.name) ?? "Error" : safeToken(record.name) ?? typeof error;
  const status = Number.isInteger(record.status) &&
    (record.status as number) >= 400 && (record.status as number) <= 599 ?
    record.status as number : undefined;
  return {
    errorName,
    ...(status === undefined ? {} : {status}),
    ...(safeToken(record.code) === undefined ? {} : {code: safeToken(record.code)}),
    ...(safeToken(record.type) === undefined ? {} : {type: safeToken(record.type)}),
  };
}

async function consumeRateLimit(uid: string): Promise<void> {
  const db = getFirestore();
  const ref = db.collection("copilot_rate_limits").doc(uid);
  const now = Timestamp.now();
  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    const data = snapshot.data();
    const last = data?.lastRequestAt instanceof Timestamp ? data.lastRequestAt.toMillis() : 0;
    const start = data?.windowStartedAt instanceof Timestamp ? data.windowStartedAt.toMillis() : 0;
    const rawCount = data?.count;
    const previousCount = Number.isInteger(rawCount) ? rawCount as number : 0;
    const next = nextRateLimitState({
      nowMs: now.toMillis(),
      lastRequestMs: last,
      windowStartedMs: start,
      count: previousCount,
    });
    transaction.set(ref, {
      windowStartedAt: Timestamp.fromMillis(next.windowStartedMs),
      lastRequestAt: now,
      count: next.count,
    });
  });
}

export const planTripWithCopilot = functions
  .runWith({secrets: ["OPENAI_API_KEY"], timeoutSeconds: 45, memory: "256MB"})
  .https.onCall(async (rawData, context) => {
    const uid = authenticatedUid(context.auth);
    const input = parsePlanRequest(rawData);
    await consumeRateLimit(uid);
    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "AI planning is not configured. Use manual trip search for now."
      );
    }

    const safeRequest = redactContactDetails(input.request);
    const client = new OpenAI({apiKey, timeout: 30_000, maxRetries: 1});
    try {
      const response = await client.responses.create({
        model: MODEL,
        store: false,
        reasoning: {effort: "none"},
        max_output_tokens: 1200,
        instructions: [
          "You interpret ride-share and package-delivery requests into a draft only.",
          "Never book, save, guarantee a match, approve identity, label a person safe, or make emergency decisions.",
          "Use find for someone seeking a ride/delivery and offer for someone driving or carrying a package.",
          "Use ride for passenger travel and package for package-only delivery.",
          "Resolve relative dates from the supplied currentDate and timezone.",
          "Normalize recognizable place names to commonly used English names for matching, even when the request is Arabic.",
          "If essential origin, destination, or departure date is absent, list it and ask one concise clarification question.",
          "Write the summary and clarification in the request language. Do not invent details.",
        ].join(" "),
        input: JSON.stringify({
          request: safeRequest,
          locale: input.locale,
          timezone: input.timezone,
          currentDate: new Date().toISOString(),
        }),
        text: {
          format: {
            type: "json_schema",
            name: "fitareeaee_trip_draft",
            strict: true,
            schema: draftSchema,
          },
        },
      });
      if (!response.output_text) throw new Error("Model returned no structured draft");
      const draft = validateDraft(JSON.parse(response.output_text));
      return {
        schemaVersion: 1,
        model: MODEL,
        piiRedacted: safeRequest !== input.request,
        draft,
      };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) throw error;
      functions.logger.error("Copilot planning failed", safeOpenAIErrorMetadata(error));
      throw new functions.https.HttpsError(
        "unavailable",
        "AI planning is temporarily unavailable. Retry or use manual search."
      );
    }
  });
