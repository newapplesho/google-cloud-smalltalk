---
paths:
  - "src/**/*.st"
---

# google-cloud-smalltalk — Project Conventions

This file holds everything **specific to this project**. The other rules files
(`pharo-syntax.md`, `rest-api-patterns.md`, `testing.md`) are generic and
reusable; when starting a new Smalltalk library, copy those and rewrite only this
file.

## Class Prefixes

| Prefix | Used by |
|--------|---------|
| `Google` | shared infrastructure (`GoogleHttpClient`, `GoogleAPIClient`, `GoogleAuthClient`, `GoogleGenAIClient`, …) |
| `Gemini` | GenAI request/response domain types (`GeminiRequest`, `GeminiTool`, `GeminiPart`, …) |
| `BigQuery` | BigQuery domain types (`BigQueryClient`, `BigQueryQueryResponse`, …) |

## Packages

| Package | Role |
|---------|------|
| `Google-Core` | HTTP/REST foundation (`GoogleHttpClient`, `GoogleAPIClient`, `GoogleRestResponse`, `GoogleRestException`) |
| `Google-Auth` | GCP authentication (ADC, service-account JWT, OAuth2) |
| `Google-GenAI` | Gemini client and domain types |
| `Google-BigQuery` | BigQuery client and domain types |
| `BaselineOfGoogleCloud` | Metacello baseline |
| `Google-*-Tests` | SUnit tests, one package per feature area |

Dependencies: `Google-Auth` → NeoJSON, JSONWebToken; `Google-Core` → Google-Auth;
`Google-GenAI` and `Google-BigQuery` → Google-Core. New classes live in the
existing packages, so no baseline edit is needed when adding a class. The
`.smalltalk.ston` test spec matches packages by the `Google-*` glob, so new test
classes are auto-discovered.

## Custom Protocol Names

In addition to the standard set in `pharo-syntax.md`:

```
'rest api'             public client calls (generateContent:, chat:, query:)
'function calling'     tool-related client calls and helpers
'building'             buildUrlFor:, request construction helpers
'default'              defaultConfig, defaultClient, defaultResponseClass
```

## Gemini Models

`GoogleGenAIConfig class>>supportedModels` is the source of truth; the first
entry is the default.

| Model | Notes |
|-------|-------|
| `gemini-2.5-flash` | **default** — fast, function-calling capable |
| `gemini-2.5-pro` | most capable |
| `gemini-2.0-flash` | previous-generation flash |

When adding a model, update `supportedModels` and `docs/gemini.md` together.

## Gemini Domain Model (function calling)

Mirrors Python `google-genai`. A message (`GeminiChatMessage`) has a `role` and
an ordered list of `parts` (`GeminiPart`); each part is text, a `functionCall`
(`GeminiFunctionCall`), or a `functionResponse` (`GeminiFunctionResponse`).
`content` / `content:` remain as a text-only convenience.

| Wire field | Class | Builder |
|------------|-------|---------|
| `tools[].functionDeclarations[]` | `GeminiTool` / `GeminiFunctionDeclaration` | `addFunctionDeclaration:`, `parameterNamed:type:description:`, `requiredParameters:` |
| `toolConfig.functionCallingConfig` | `GeminiToolConfig` | `mode:allowedFunctionNames:` |
| `systemInstruction` | (string on `GeminiRequest`) | `systemInstruction:` |
| `contents[].parts[]` | `GeminiPart` | `text:`, `functionCall:`, `functionResponse:` |

Client entry points: `generateContent:tools:`, `chat:tools:`, and the automatic
`runConversation:tools:handlers:` loop (see `rest-api-patterns.md`).

## Error Handling

`GoogleRestException` for core HTTP/REST errors; `GeminiError` for GenAI errors.
Both subclass `Error` and are **signalled** (not returned). Callers use
`[ ... ] on: GeminiError do: [ :e | e messageText ]`. Do not type-switch on a
returned value (`isKindOf:`).

## Authentication

`GoogleAuthClient` loads Application Default Credentials via
`GoogleCredentialLoader`: the `GOOGLE_APPLICATION_CREDENTIALS` env var first, then
`~/.config/gcloud/application_default_credentials.json`. Service accounts sign an
RS256 JWT (`JSONWebToken`) and exchange it for an OAuth2 access token.

## Documentation Style

- In Japanese text, do not put a space between Japanese characters and Latin
  characters (English words, code, numbers) — e.g. `Geminiで`, `function calling`.
- Do not use `→`. Express references with `：` and connections with words like
  `と` / `して`.

## Reference Docs

- Gemini usage: `docs/gemini.md`
- Authentication: `docs/getting-started.md`
- BigQuery: `docs/bigquery.md`
- Gemini API (function calling) source of truth:
  https://ai.google.dev/gemini-api/docs/function-calling and the Python
  `google-genai` SDK.
