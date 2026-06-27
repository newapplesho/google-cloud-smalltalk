# Roadmap

What you can do with Google Cloud services from Pharo Smalltalk today, and what
is coming next. The driving goal is a clean **Google Cloud client for Pharo**
that progressively supports the major GCP services — prioritizing Google
Cloud's distinctive **managed services**. Near-term priorities are **Cloud
Storage**, **Vertex AI** (expanding past today's Gemini-only support), and **BigQuery**.
Items are grouped by service and, for GenAI, staged as a checklist toward the
full feature set. Contributions and feature requests are welcome — please open
an issue.

Gemini **function calling** is already implemented (typed tool declarations
plus an automatic tool loop); one use case it enables is driving a separate
**Google ADK (Agent Development Kit)** library, but ADK is not a goal of this
repository (this is the client library only).

References: [BigQuery REST API](https://cloud.google.com/bigquery/docs/reference/rest),
[Cloud Storage JSON API](https://cloud.google.com/storage/docs/json_api),
[Vertex AI REST API](https://cloud.google.com/vertex-ai/docs/reference/rest),
[Gemini API docs](https://ai.google.dev/gemini-api/docs),
[function calling](https://ai.google.dev/gemini-api/docs/function-calling),
the Python [`google-genai`](https://github.com/googleapis/python-genai) SDK.

## Available now

- [x] Gemini single-turn generation (`generateContent:`) and multi-turn chat (`chat:`)
- [x] Vertex AI and API-Key (Generative Language) endpoints
- [x] GCP authentication: Application Default Credentials, service-account JWT, OAuth2
- [x] BigQuery query execution and dataset management
- [x] CI on Pharo 12 and 13 via smalltalkCI

## GenAI feature staging (function calling toward full SDK parity)

The path from today's text-only client to `google-genai`-level coverage.

### Stage 1 — Function calling & latest models (merged — PR #15)

- [x] `GeminiFunctionDeclaration` with `parameterNamed:type:description:` /
      `requiredParameters:` schema builders
- [x] `GeminiTool` (`functionDeclarations`) and `GeminiToolConfig`
      (`functionCallingConfig` mode: AUTO / ANY / NONE + allowedFunctionNames)
- [x] Typed message parts: `GeminiPart` (text / functionCall / functionResponse),
      `GeminiFunctionCall`, `GeminiFunctionResponse`
- [x] Multi-part messages on `GeminiChatMessage` (backward-compatible `content`)
- [x] `tools` / `toolConfig` / `systemInstruction` on requests
- [x] Response inspection: `hasFunctionCall`, `functionCalls`, candidate `parts`
- [x] Client primitives: `generateContent:tools:`, `chat:tools:`
- [x] Automatic tool loop: `runConversation:tools:handlers:`
- [x] Default model `gemini-2.5-flash`; `supportedModels` list

### Stage 2 — Streaming

- [ ] `streamGenerateContent` over server-sent events, yielding incremental
      candidates (text and partial function calls)
- [ ] Streaming-friendly response accumulation API

### Stage 3 — Structured output

- [x] `responseMimeType` (`application/json`) and `responseSchema` on
      `generationConfig` (`GeminiRequest>>responseMimeType:` / `responseSchema:`,
      sent via `client send:`)
- [x] Parse structured results with `GeminiResponse>>json`
- [ ] Enum / constrained decoding helpers
- [ ] Convenience to map structured JSON onto typed Smalltalk objects

### Stage 4 — Multimodal input

- [ ] Inline data parts (`inlineData`: base64 images, PDF, audio) on messages
- [ ] File-reference parts (`fileData`) once the File API (Stage 5) lands
- [ ] Builders on `GeminiPart` for binary / mime-typed content

### Stage 5 — Wider Gemini surface

- [ ] Token counting (`countTokens`)
- [ ] Embeddings (`text-embedding-004` / `embedContent`; Vertex AI as well as
      the Generative Language endpoint)
- [ ] File API (upload / reference large media)
- [ ] Built-in tools: Google Search grounding, code execution
- [ ] `usageMetadata` (token counts) and `safetyRatings` accessors on responses
- [ ] Cached content / context caching

### Stage 6 — Examples & releases

- [ ] Worked examples in `docs/` for the function-calling loop
      (`runConversation:tools:handlers:`), including one ADK integration example
      (ADK itself lives in a separate library and consumes these primitives)
- [ ] Tagged releases installable via Metacello `github://`

## Vertex AI

Broaden the Vertex AI surface beyond today's Gemini text generation toward its
managed-ML offerings.

- [x] Vertex AI endpoint for Gemini generation
- [ ] Embeddings via Vertex AI (`text-embedding-*` / `predict`)
- [ ] Online prediction (`predict` / `rawPredict`) for deployed models
- [ ] Model / endpoint discovery helpers

## BigQuery

- [x] Query execution with configurable settings (dryRun, maxResults, timeout)
- [ ] Job management (insert / poll long-running jobs)
- [ ] Table and schema management helpers
- [ ] Paginated result iteration for large result sets
- [ ] Load / export jobs (GCS ↔ BigQuery)

## Cloud Storage

Object storage, useful on its own and to back BigQuery load / export jobs.

- [ ] Object upload / download (single-request and resumable)
- [ ] Bucket and object listing / metadata
- [ ] GCS ↔ BigQuery load / export integration

## Cross-cutting / developer experience

- [x] Access-token caching / reuse across requests (wired `GoogleAuthClient`
      `tokenCache` + `GoogleOauth2RefreshResponse>>isExpired`)
- [x] `Makefile` + `scripts/` for the Pharo load / test / UI cycle
- [ ] Retry with backoff on transient HTTP errors (429 / 5xx)
- [ ] Per-feature documentation kept in sync with `supportedModels`
- [ ] Windows CI coverage
- [ ] Further GCP services (Pub/Sub, Firestore, …) as separate `Google-*` packages
