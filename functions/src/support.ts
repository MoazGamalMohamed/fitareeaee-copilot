import {getFirestore, Timestamp} from "firebase-admin/firestore";
import * as functions from "firebase-functions/v1";
import OpenAI from "openai";
import {
  redactContactDetails,
  safeOpenAIErrorMetadata,
  safetyIdentifierForUid,
} from "./copilot";

const MODEL = "gpt-5.6";
const CATEGORIES = new Set([
  "payment", "trip", "account", "safety", "technical", "other",
]);
const MAX_MESSAGE_LENGTH = 2_000;
const MAX_CALLS_PER_HOUR = 20;
const MIN_INTERVAL_MS = 3_000;

export interface SupportInput {
  schemaVersion: 1;
  category: string;
  subject: string;
  message: string;
  tripId: string | null;
}

export interface SupportAnswer {
  schemaVersion: 1;
  answer: string;
  shouldEscalate: boolean;
  urgency: "normal" | "priority";
}

const answerSchema = {
  type: "object",
  additionalProperties: false,
  required: ["schemaVersion", "answer", "shouldEscalate", "urgency"],
  properties: {
    schemaVersion: {type: "integer", enum: [1]},
    answer: {type: "string"},
    shouldEscalate: {type: "boolean"},
    urgency: {type: "string", enum: ["normal", "priority"]},
  },
} as const;

function object(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new functions.https.HttpsError("invalid-argument", "Support details are required.");
  }
  return value as Record<string, unknown>;
}

function boundedText(value: unknown, label: string, minimum: number, maximum: number): string {
  if (typeof value !== "string") {
    throw new functions.https.HttpsError("invalid-argument", `${label} is required.`);
  }
  const normalized = value.trim();
  if (normalized.length < minimum || normalized.length > maximum) {
    throw new functions.https.HttpsError("invalid-argument", `${label} is invalid.`);
  }
  return normalized;
}

function validId(value: unknown): value is string {
  return typeof value === "string" && value.length > 0 &&
    value.length <= 128 && !value.includes("/");
}

export function parseSupportInput(value: unknown): SupportInput {
  const data = object(value);
  if (data.schemaVersion !== undefined && data.schemaVersion !== 1) {
    throw new functions.https.HttpsError("invalid-argument", "Unsupported support version.");
  }
  const category = typeof data.category === "string" ? data.category : "";
  if (!CATEGORIES.has(category)) {
    throw new functions.https.HttpsError("invalid-argument", "Choose a support category.");
  }
  const tripId = data.tripId === null || data.tripId === undefined ? null : data.tripId;
  if (tripId !== null && !validId(tripId)) {
    throw new functions.https.HttpsError("invalid-argument", "Trip reference is invalid.");
  }
  return {
    schemaVersion: 1,
    category,
    subject: boundedText(data.subject, "Subject", 2, 120),
    message: boundedText(data.message, "Message", 2, MAX_MESSAGE_LENGTH),
    tripId,
  };
}

export function validateSupportAnswer(value: unknown): SupportAnswer {
  const data = object(value);
  const keys = new Set(["schemaVersion", "answer", "shouldEscalate", "urgency"]);
  if (Object.keys(data).some((key) => !keys.has(key)) || data.schemaVersion !== 1) {
    throw new Error("Support answer schema is invalid");
  }
  const answer = typeof data.answer === "string" ? data.answer.trim() : "";
  if (answer.length < 2 || answer.length > 1_200 ||
      typeof data.shouldEscalate !== "boolean" ||
      (data.urgency !== "normal" && data.urgency !== "priority")) {
    throw new Error("Support answer is invalid");
  }
  return {
    schemaVersion: 1,
    answer,
    shouldEscalate: data.shouldEscalate,
    urgency: data.urgency,
  };
}

async function consumeRateLimit(uid: string): Promise<void> {
  const db = getFirestore();
  const ref = db.collection("support_ai_rate_limits").doc(uid);
  const now = Timestamp.now();
  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    const data = snapshot.data() ?? {};
    const last = data.lastRequestAt instanceof Timestamp ? data.lastRequestAt.toMillis() : 0;
    const start = data.windowStartedAt instanceof Timestamp ?
      data.windowStartedAt.toMillis() : 0;
    const previous = Number.isInteger(data.count) ? data.count as number : 0;
    if (now.toMillis() - last < MIN_INTERVAL_MS) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        "Wait a few seconds before sending another support question."
      );
    }
    const inWindow = now.toMillis() - start < 60 * 60 * 1000;
    if (inWindow && previous >= MAX_CALLS_PER_HOUR) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        "The hourly AI support limit was reached. Escalate this ticket to a person."
      );
    }
    transaction.set(ref, {
      windowStartedAt: Timestamp.fromMillis(inWindow ? start : now.toMillis()),
      lastRequestAt: now,
      count: (inWindow ? previous : 0) + 1,
    });
  });
}

async function answerSupportQuestion(input: {
  category: string;
  subject: string;
  message: string;
  history: Array<{speaker: string; message: string}>;
}, uid: string): Promise<SupportAnswer> {
  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) throw new Error("AI support is not configured");
  const client = new OpenAI({apiKey, timeout: 30_000, maxRetries: 1});
  const response = await client.responses.create({
    model: MODEL,
    store: false,
    safety_identifier: safetyIdentifierForUid(uid),
    reasoning: {effort: "none"},
    max_output_tokens: 700,
    instructions: [
      "You are the first-line Fitareeaee support assistant.",
      "Give concise practical product guidance using only the supplied category, subject, message, and limited ticket history.",
      "Never claim to inspect an account, trip, payment, identity document, or live location.",
      "Never approve refunds, payments, identity, safety, bans, bookings, or emergency actions.",
      "Do not request passwords, full payment-card details, full government-ID numbers, phone numbers, email addresses, or private documents.",
      "Set shouldEscalate true for account-specific actions, payment/refund disputes, identity decisions, threats, emergencies, legal requests, unresolved technical failures, or uncertainty.",
      "For possible immediate danger, advise contacting local emergency services first and set urgency priority.",
      "State important limitations honestly. Do not invent policy or operational status.",
    ].join(" "),
    input: JSON.stringify(input),
    text: {
      format: {
        type: "json_schema",
        name: "fitareeaee_support_answer",
        strict: true,
        schema: answerSchema,
      },
    },
  });
  if (!response.output_text) throw new Error("Model returned no support answer");
  return validateSupportAnswer(JSON.parse(response.output_text));
}

async function writeAiAnswer(
  ticketId: string,
  answer: SupportAnswer
): Promise<void> {
  const db = getFirestore();
  const ticketRef = db.collection("support_tickets").doc(ticketId);
  const now = Timestamp.now();
  await Promise.all([
    ticketRef.collection("messages").add({
      ticketId,
      senderId: "support-ai",
      senderName: "Fitareeaee AI Support (GPT-5.6)",
      isStaff: true,
      isAutomated: true,
      message: answer.answer,
      attachments: [],
      createdAt: now,
    }),
    ticketRef.set({
      aiStatus: "answered",
      escalated: answer.shouldEscalate,
      priority: answer.urgency,
      status: answer.shouldEscalate ? "inProgress" : "open",
      updatedAt: now,
    }, {merge: true}),
  ]);
}

async function escalateAfterFailure(ticketId: string): Promise<void> {
  const db = getFirestore();
  const ticketRef = db.collection("support_tickets").doc(ticketId);
  const now = Timestamp.now();
  await Promise.all([
    ticketRef.collection("messages").add({
      ticketId,
      senderId: "support-system",
      senderName: "Fitareeaee Support",
      isStaff: true,
      isAutomated: true,
      message: "AI support is unavailable, so this ticket was escalated to a human support reviewer.",
      attachments: [],
      createdAt: now,
    }),
    ticketRef.set({
      aiStatus: "unavailable",
      escalated: true,
      priority: "normal",
      status: "inProgress",
      updatedAt: now,
    }, {merge: true}),
  ]);
}

export const contactSupport = functions
  .runWith({secrets: ["OPENAI_API_KEY"], timeoutSeconds: 45, memory: "256MB"})
  .https.onCall(async (rawData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Sign in to contact support.");
    }
    const input = parseSupportInput(rawData);
    await consumeRateLimit(context.auth.uid);
    const db = getFirestore();
    const ticketRef = db.collection("support_tickets").doc();
    const now = Timestamp.now();
    await ticketRef.set({
      id: ticketRef.id,
      userId: context.auth.uid,
      tripId: input.tripId,
      category: input.category,
      status: "open",
      subject: input.subject,
      description: input.message,
      escalated: false,
      priority: "normal",
      aiStatus: "processing",
      createdAt: now,
      updatedAt: now,
    });
    await ticketRef.collection("messages").add({
      ticketId: ticketRef.id,
      senderId: context.auth.uid,
      senderName: "You",
      isStaff: false,
      isAutomated: false,
      message: input.message,
      attachments: [],
      createdAt: now,
    });

    try {
      const answer = await answerSupportQuestion({
        category: input.category,
        subject: redactContactDetails(input.subject),
        message: redactContactDetails(input.message),
        history: [],
      }, context.auth.uid);
      await writeAiAnswer(ticketRef.id, answer);
      return {
        schemaVersion: 1,
        ticketId: ticketRef.id,
        aiAnswered: true,
        escalated: answer.shouldEscalate,
      };
    } catch (error) {
      functions.logger.error("AI support response failed", safeOpenAIErrorMetadata(error));
      await escalateAfterFailure(ticketRef.id);
      return {
        schemaVersion: 1,
        ticketId: ticketRef.id,
        aiAnswered: false,
        escalated: true,
      };
    }
  });

export const sendSupportMessage = functions
  .runWith({secrets: ["OPENAI_API_KEY"], timeoutSeconds: 45, memory: "256MB"})
  .https.onCall(async (rawData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Sign in to contact support.");
    }
    const data = object(rawData);
    const ticketId = data.ticketId;
    if (!validId(ticketId)) {
      throw new functions.https.HttpsError("invalid-argument", "Ticket is invalid.");
    }
    const message = boundedText(data.message, "Message", 2, MAX_MESSAGE_LENGTH);
    const db = getFirestore();
    const ticketRef = db.collection("support_tickets").doc(ticketId);
    const ticket = await ticketRef.get();
    const ticketData = ticket.data() ?? {};
    if (!ticket.exists || ticketData.userId !== context.auth.uid) {
      throw new functions.https.HttpsError("permission-denied", "You cannot update this ticket.");
    }
    if (ticketData.status === "closed" || ticketData.status === "resolved") {
      throw new functions.https.HttpsError("failed-precondition", "This ticket is closed.");
    }
    const now = Timestamp.now();
    await ticketRef.collection("messages").add({
      ticketId,
      senderId: context.auth.uid,
      senderName: "You",
      isStaff: false,
      isAutomated: false,
      message,
      attachments: [],
      createdAt: now,
    });
    await ticketRef.set({updatedAt: now}, {merge: true});
    if (ticketData.escalated === true) {
      return {schemaVersion: 1, ticketId, aiAnswered: false, escalated: true};
    }

    await consumeRateLimit(context.auth.uid);
    const historySnapshot = await ticketRef
      .collection("messages")
      .orderBy("createdAt", "desc")
      .limit(8)
      .get();
    const history = historySnapshot.docs.reverse().map((document) => {
      const item = document.data();
      return {
        speaker: item.isStaff === true ? "support" : "user",
        message: redactContactDetails(
          typeof item.message === "string" ? item.message.slice(0, 1_200) : ""
        ),
      };
    });
    try {
      const answer = await answerSupportQuestion({
        category: typeof ticketData.category === "string" ? ticketData.category : "other",
        subject: redactContactDetails(
          typeof ticketData.subject === "string" ? ticketData.subject : "Support request"
        ),
        message: redactContactDetails(message),
        history,
      }, context.auth.uid);
      await writeAiAnswer(ticketId, answer);
      return {
        schemaVersion: 1,
        ticketId,
        aiAnswered: true,
        escalated: answer.shouldEscalate,
      };
    } catch (error) {
      functions.logger.error("AI support follow-up failed", safeOpenAIErrorMetadata(error));
      await escalateAfterFailure(ticketId);
      return {schemaVersion: 1, ticketId, aiAnswered: false, escalated: true};
    }
  });

export const escalateSupportTicket = functions.https.onCall(async (rawData, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in to contact support.");
  }
  const data = object(rawData);
  const ticketId = data.ticketId;
  if (!validId(ticketId)) {
    throw new functions.https.HttpsError("invalid-argument", "Ticket is invalid.");
  }
  const db = getFirestore();
  const ticketRef = db.collection("support_tickets").doc(ticketId);
  const ticket = await ticketRef.get();
  const ticketData = ticket.data() ?? {};
  if (!ticket.exists || ticketData.userId !== context.auth.uid) {
    throw new functions.https.HttpsError("permission-denied", "You cannot escalate this ticket.");
  }
  if (ticketData.status === "closed" || ticketData.status === "resolved") {
    throw new functions.https.HttpsError("failed-precondition", "This ticket is closed.");
  }
  if (ticketData.escalated !== true) {
    const now = Timestamp.now();
    await Promise.all([
      ticketRef.set({
        escalated: true,
        status: "inProgress",
        updatedAt: now,
      }, {merge: true}),
      ticketRef.collection("messages").add({
        ticketId,
        senderId: "support-system",
        senderName: "Fitareeaee Support",
        isStaff: true,
        isAutomated: true,
        message: "This conversation was escalated to a human support reviewer.",
        attachments: [],
        createdAt: now,
      }),
    ]);
  }
  return {schemaVersion: 1, ticketId, escalated: true};
});
