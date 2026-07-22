/*
 * Owner-only Build Week judge account provisioner.
 * Generates credentials into a Git-ignored local file and never logs passwords.
 */
const crypto = require("node:crypto");
const fs = require("node:fs");
const path = require("node:path");
const {execFileSync} = require("node:child_process");
const {getApps, initializeApp} = require("firebase-admin/app");
const {getAuth} = require("firebase-admin/auth");

const EXPECTED_PROJECT = "fitareeaee";
const confirmation = process.env.PROVISION_JUDGE_USERS;
const credentialsPath = path.resolve(
  __dirname,
  "../../.judge-credentials.local.json",
);

function fail(message) {
  process.stderr.write(`Judge provisioning refused: ${message}\n`);
  process.exit(1);
}

function safeErrorDetail(error) {
  const raw = String(error?.message || error?.errorInfo?.message || "");
  return raw
    .replace(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/gi, "[redacted-email]")
    .replace(/[A-Za-z0-9_-]{32,}/g, "[redacted-token]")
    .slice(0, 300);
}

function createPassword() {
  return `${crypto.randomBytes(24).toString("base64url")}Aa1!`;
}

if (confirmation !== EXPECTED_PROJECT) {
  fail(`PROVISION_JUDGE_USERS must equal ${EXPECTED_PROJECT}.`);
}

function createCredentials() {
  const stamp = `${Date.now()}-${crypto.randomBytes(4).toString("hex")}`;
  return {
    projectId: EXPECTED_PROJECT,
    createdAt: new Date().toISOString(),
    accounts: {
      driver: {
        email: `fitareeaee-judge-driver-${stamp}@example.test`,
        password: createPassword(),
        uid: null,
      },
      rider: {
        email: `fitareeaee-judge-rider-${stamp}@example.test`,
        password: createPassword(),
        uid: null,
      },
    },
  };
}

function validCredentials(value) {
  if (value?.projectId !== EXPECTED_PROJECT) return false;
  for (const role of ["driver", "rider"]) {
    const account = value?.accounts?.[role];
    if (
      typeof account?.email !== "string" ||
      !account.email.endsWith("@example.test") ||
      typeof account?.password !== "string" ||
      account.password.length < 20
    ) return false;
  }
  return true;
}

function saveCredentials(value) {
  fs.writeFileSync(
    credentialsPath,
    `${JSON.stringify(value, null, 2)}\n`,
    {encoding: "utf8", mode: 0o600},
  );
}

function loadOrCreateCredentials() {
  if (!fs.existsSync(credentialsPath)) {
    const created = createCredentials();
    saveCredentials(created);
    return created;
  }
  const existing = JSON.parse(fs.readFileSync(credentialsPath, "utf8"));
  if (!validCredentials(existing)) {
    fail("the existing local credential file is malformed or for another project.");
  }
  return existing;
}

function getOwnerAccessToken() {
  const output = execFileSync(
    "cmd.exe",
    [
      "/d",
      "/s",
      "/c",
      `gcloud auth print-access-token --project ${EXPECTED_PROJECT}`,
    ],
    {
      encoding: "utf8",
      windowsHide: true,
      stdio: ["ignore", "pipe", "pipe"],
    },
  ).trim();
  if (output.length < 20) fail("Google Cloud did not return an access token.");
  return output;
}

async function ensureUser(auth, role, account) {
  const displayName = role === "driver" ? "Judge Driver" : "Judge Rider";
  let user;
  try {
    user = await auth.getUserByEmail(account.email);
    if (user.displayName !== displayName) {
      fail(`the existing ${role} email is not a Fitareeaee judge fixture.`);
    }
    user = await auth.updateUser(user.uid, {
      password: account.password,
      emailVerified: true,
      disabled: false,
    });
  } catch (error) {
    if (error?.code !== "auth/user-not-found") throw error;
    user = await auth.createUser({
      email: account.email,
      password: account.password,
      emailVerified: true,
      displayName,
      disabled: false,
    });
  }
  return user.uid;
}

async function main() {
  const credentials = loadOrCreateCredentials();
  const rotatePasswords =
    process.env.ROTATE_JUDGE_PASSWORDS === EXPECTED_PROJECT;
  if (rotatePasswords) {
    credentials.accounts.driver.password = createPassword();
    credentials.accounts.rider.password = createPassword();
    credentials.rotatedAt = new Date().toISOString();
    saveCredentials(credentials);
  }
  const accessToken = getOwnerAccessToken();
  // Firebase Admin adds this as x-goog-user-project for owner user credentials.
  // Without it, Identity Toolkit rejects an otherwise valid gcloud access token.
  process.env.GOOGLE_CLOUD_QUOTA_PROJECT = EXPECTED_PROJECT;
  const credential = {
    getAccessToken: async () => ({
      access_token: accessToken,
      expires_in: 3600,
    }),
  };
  const app = getApps()[0] || initializeApp({
    projectId: EXPECTED_PROJECT,
    credential,
  });
  const auth = getAuth(app);

  credentials.accounts.driver.uid = await ensureUser(
    auth,
    "driver",
    credentials.accounts.driver,
  );
  saveCredentials(credentials);
  credentials.accounts.rider.uid = await ensureUser(
    auth,
    "rider",
    credentials.accounts.rider,
  );
  saveCredentials(credentials);

  process.env.GOOGLE_CLOUD_PROJECT = EXPECTED_PROJECT;
  process.env.JUDGE_DRIVER_UID = credentials.accounts.driver.uid;
  process.env.JUDGE_RIDER_UID = credentials.accounts.rider.uid;
  if (!rotatePasswords || process.env.RESET_JUDGE_DATA === EXPECTED_PROJECT) {
    const {seedJudgeData} = require("./seed-judge-data.cjs");
    await seedJudgeData({
      accessToken,
      driverEmail: credentials.accounts.driver.email,
      riderEmail: credentials.accounts.rider.email,
    });
  }

  process.stdout.write(
    `${rotatePasswords ? "Rotated fictional judge passwords; existing fixtures were preserved" : "Provisioned fictional judge users and fixtures"}. Credentials remain only at ${credentialsPath}.\n`,
  );
}

main().catch((error) => {
  const detail = safeErrorDetail(error);
  process.stderr.write(
    `Judge provisioning failed (${error?.code || error?.name || "Error"}). ` +
    `${detail || "No additional service detail."} ` +
    "No credentials were logged.\n",
  );
  process.exitCode = 1;
});
