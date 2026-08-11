---
paths:
  - "src/*-Tests/**/*.st"
---

# Testing Conventions

This file is **project-independent** — it can be copied as-is to any Pharo project.
Project-specific test fixtures are described in `project-conventions.md`.

## setUp / tearDown

Acquire shared fixtures in `setUp`; tests must be independent (no shared state
across test methods).

```smalltalk
GeminiFunctionCallingTest >> setUp [
    super setUp.
    client := GeminiStubClient new.
]
```

## No live network in unit tests

Unit tests must **never** make real HTTP calls or require credentials. The CI
runs offline. To test client behaviour, use a stub:

- `GeminiStubClient` (in `Google-GenAI-Tests`) subclasses `GoogleGenAIClient` and
  overrides `sendRequest:` to return queued JSON strings, recording each sent
  payload in `sentPayloads`.
- For request/response classes, assert against `asJson` / `fromJson:` with
  literal JSON fixtures (see `GeminiResponseTest`, `GeminiRequestTest`).

A live, credentialed smoke test may exist but must be excluded from the default
CI suite.

## Test Method Naming

`test` + what is tested + expected outcome.

```
testFromJsonWithFunctionCallParsesName
testAutoLoopExecutesHandlerAndReturnsFinalText
testDefaultModelIsGemini25Flash
```

## Assertions

```smalltalk
self assert: x equals: y.          "prefer over assert: (x = y)"
self assert: x.
self deny: x.
self assert: (json includesSubstring: 'functionResponse').
self should: [ client chat: bad ] raise: GeminiError.
```

Prefer `assert:equals:` over `assert: (x = y)` — gives better failure messages.

For URL and exact-value assertions, prefer `assert:equals:` over
`includesSubstring:`. A substring match can mask bugs (e.g. `??key=` passes when
matched against `?key=`):

```smalltalk
"--- NG: substring match hides double-? bug ---"
self assert: (url includesSubstring: '?key=').

"--- OK: exact match catches ??key= ---"
self assert: url equals: 'https://example.com/v1/models/gemini:op?key=test'.
```

## JSON round-trip pattern

When testing serialization, parse the produced JSON back with `NeoJSONReader`
and assert on the resulting dictionary rather than matching raw strings (key
order is not guaranteed):

```smalltalk
parsed := NeoJSONReader fromString: request asJson.
self assert: ((parsed at: 'tools') first at: 'functionDeclarations') size equals: 1.
```
