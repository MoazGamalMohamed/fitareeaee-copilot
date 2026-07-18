# Backend Setup

The pre-Build-Week backend notes were removed because they described deleted
payment, email, OpenRouter, permissive-rule, and client-secret prototypes.

The authoritative setup is now:

- [`../README.md`](../README.md) for Flutter/Firebase/OpenAI configuration;
- [`JUDGE_TESTING.md`](JUDGE_TESTING.md) for the judge path;
- [`PRIVACY_AND_SAFETY.md`](PRIVACY_AND_SAFETY.md) for data boundaries;
- [`../firestore.rules`](../firestore.rules), [`../storage.rules`](../storage.rules),
  and [`../firestore.indexes.json`](../firestore.indexes.json) for deployed policy;
- `functions/src/` for the only deployable server exports.

Never place OpenAI or other server credentials in Dart, `.env`, Android
resources, documentation, logs, or an APK. `OPENAI_API_KEY` is required only as
a managed Firebase Functions secret.
