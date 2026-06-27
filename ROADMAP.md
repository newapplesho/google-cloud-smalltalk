# Roadmap

What you can do with Google Cloud services from Pharo Smalltalk today, and what
is coming next. The driving goal is a clean, complete **Gemini** surface that a
separate **Google ADK (Agent Development Kit)** library can build on — which
means first-class **function calling**. Items are grouped by theme and, for
GenAI, staged as a checklist toward the full feature set. Contributions and
feature requests are welcome — please open an issue.

References: [Gemini API docs](https://ai.google.dev/gemini-api/docs),
[function calling](https://ai.google.dev/gemini-api/docs/function-calling),
the Python [`google-genai`](https://github.com/googleapis/python-genai) SDK.

## Available now

- [x] Gemini single-turn generation (`generateContent:`) and multi-turn chat (`chat:`)
- [x] Vertex AI and API-Key (Generative Language) endpoints
- [x] GCP authentication: Application Default Credentials, service-account JWT, OAuth2
- [x] BigQuery query execution and dataset management
- [x] CI on Pharo 12 and 13 via smalltalkCI

## GenAI feature staging (function calling → full SDK parity)

The path from today's text-only client to `google-genai`-level coverage.

### Stage 1 — Function calling & latest models (this branch)

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
- [ ] Embeddings (`text-embedding-004` / `embedContent`)
- [ ] File API (upload / reference large media)
- [ ] Built-in tools: Google Search grounding, code execution
- [ ] `usageMetadata` (token counts) and `safetyRatings` accessors on responses
- [ ] Cached content / context caching

### Stage 6 — ADK-facing convenience layer

- [ ] Thin adapter so an ADK agent can register Smalltalk tools and run a turn
      with minimal boilerplate (built on `runConversation:tools:handlers:`)
- [ ] Worked ADK examples in `docs/`
- [ ] Tagged releases installable via Metacello `github://`

## BigQuery

- [x] Query execution with configurable settings (dryRun, maxResults, timeout)
- [ ] Job management (insert / poll long-running jobs)
- [ ] Table and schema management helpers
- [ ] Paginated result iteration for large result sets
- [ ] Load / export jobs (GCS ↔ BigQuery)

## Cross-cutting / developer experience

- [x] Access-token caching / reuse across requests (wired `GoogleAuthClient`
      `tokenCache` + `GoogleOauth2RefreshResponse>>isExpired`)
- [x] `Makefile` + `scripts/` for the Pharo load / test / UI cycle
- [ ] Retry with backoff on transient HTTP errors (429 / 5xx)
- [ ] Per-feature documentation kept in sync with `supportedModels`
- [ ] Windows CI coverage
- [ ] Additional GCP services (Cloud Storage, Pub/Sub, …) as separate `Google-*` packages
