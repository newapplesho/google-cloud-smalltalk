---
paths:
  - "src/Google-*/**/*.st"
---

# REST API Patterns

This file is **reusable** for any Pharo library that wraps an HTTP/JSON REST API
with Zinc (`ZnClient`) + NeoJSON. Snippets use this project as a worked example.
This project has **no UFFI** — there is no native library to load.

## Layers

```
GoogleGenAIClient / BigQueryClient   ← service clients (extend GoogleAPIClient)
  └─ GoogleAPIClient                 ← projectId / location, holds an http client
       └─ GoogleHttpClient          ← Bearer auth + request/response plumbing
            └─ ZnClient             ← Pharo Zinc HTTP
```

Service clients build a request object, serialize it with `asJson`, POST it via
`self client httpPost:contents:`, and parse the response body with a
`...fromJson:` class method.

## Authentication (Bearer token)

`GoogleHttpClient>>createRequest` attaches `Bearer <token>` when an `authClient`
is set. The token comes from `GoogleAuthClient>>getAccessToken`, which loads
Application Default Credentials (service-account JWT or user credentials) via
`GoogleCredentialLoader`.

- For Vertex AI endpoints, a Bearer token is required.
- For the API-Key (`generativelanguage.googleapis.com`) endpoint, no token is
  used — clear it with `self client authClient: nil` and pass `?key=` in the URL
  (see `GoogleGenAIClient>>sendRequest:`).

## Request objects: build then `asJson`

Request classes own their wire shape. Build a Dictionary/Array tree and serialize
with `NeoJSONWriter toString:`. Keep optional fields out of the payload when
empty.

```smalltalk
GeminiRequest >> asJson [
	| contents |
	contents := Dictionary new
		            at: 'contents'
		            put: (Array with: (self contentDictForText: prompt));
		            yourself.
	self addCommonFieldsTo: contents.
	^ NeoJSONWriter toString: contents
]
```

- Prefer object builders over hand-built dicts at call sites: `GeminiTool`,
  `GeminiFunctionDeclaration`, `GeminiToolConfig`, `GeminiPart` each answer
  `asDictionary`, and requests compose them.
- Subclasses share serialization via a common helper (`addCommonFieldsTo:`),
  not by copy-paste (`GeminiChatRequest` reuses `GeminiRequest`).

## Response objects: `fromJson:`

Parse with `NeoJSONReader fromString:` and read keys defensively with
`at:ifAbsent:` so a missing field never raises.

```smalltalk
GeminiResponse class >> fromJson: jsonString [
	| jsonData |
	jsonData := NeoJSONReader fromString: jsonString.
	^ self new initializeFromJson: jsonData; yourself
]
```

Expose typed accessors (`text`, `functionCalls`, `hasFunctionCall`) rather than
leaking raw dictionaries to callers.

## Endpoint building (Vertex AI vs API Key)

`GoogleGenAIConfig>>serviceEndpoint` returns the base URL per mode; clients
append the path. Vertex AI uses
`v1/projects/{projectId}/locations/{location}/publishers/google/models/{model}:generateContent`;
the API-Key endpoint uses `v1beta/models/{model}:generateContent?key={apiKey}`.
Always branch on `config useVertexAI`.

## Error handling

Use exceptions — the idiomatic Pharo way — not returned error values.

- The GenAI client **signals** a `GeminiError` (a subclass of `Error`) on both
  HTTP-transport failures (`signalHttpError:`) and non-success API responses
  (`signalApiError:`). Callers use `[ ... ] on: GeminiError do: [ :e | ... ]`.
- `GeminiError>>messageText` returns the API message so handlers read it the
  standard way; `statusCode` carries the HTTP status.
- The core layer raises `GoogleRestException` likewise.
- Do **not** type-switch on a returned object (`isKindOf: GeminiError`) — that is
  a non-Smalltalk result-value style. Signal and catch instead.

## Function calling (Gemini)

Modeled on Python `google-genai`. The round-trip is:

1. Declare tools: `GeminiFunctionDeclaration` (+ `parameterNamed:type:description:`
   / `requiredParameters:`) grouped in a `GeminiTool`.
2. Send with tools: `generateContent:tools:` / `chat:tools:`.
3. Inspect: `response hasFunctionCall`, `response functionCalls`
   (`GeminiFunctionCall` with `name` + `args`).
4. Reply: append a `GeminiFunctionResponse` part and resend.

`runConversation:tools:handlers:` automates steps 2–4: `handlers` maps a function
name to a block `[:args | aDictionary]`; the loop runs until the model stops
calling functions or `maxIterations` is hit. ADK-style callers may instead drive
the primitives directly.

For options the `...tools:` convenience methods do not expose (e.g.
`systemInstruction`, a custom `toolConfig`), build a `GeminiRequest` /
`GeminiChatRequest` and call `client send: aRequest` (the public, parsed entry
point; it defaults the model to the config's `defaultModel` when unset).
