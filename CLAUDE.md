# google-cloud-smalltalk

Pharo Smalltalk client libraries for Google Cloud Platform services (Gemini /
GenAI and BigQuery) over their HTTP/JSON REST APIs, using Zinc (`ZnClient`) and
NeoJSON. Sources are in [Tonel](https://github.com/pharo-vcs/tonel) format
(`src/`): one `.class.st` per class, one `package.st` per package.

A design goal is to be easy to consume from a separate **Google ADK (Agent
Development Kit)** library, which is driven by Gemini **function calling**.

## Commands

A `Makefile` wraps a local Pharo image in `pharo-local/` (see
[docs/development.md](docs/development.md)):

```bash
make setup   # one-time: download Pharo 13 image + VM into pharo-local/
make load    # load/reload the project into the image
make test    # run the offline test suite (pattern Google.*)
make ui      # open the Pharo GUI
```

`scripts/load-project.st` is the single source of truth for the Metacello load
expression (paste into a Playground with Ctrl+D to load manually). CI uses
[smalltalkCI](https://github.com/hpi-swa/smalltalkCI):

```bash
smalltalkci -s Pharo64-13 .smalltalk.ston   # Pharo 12 or 13
```

After editing a `.class.st` file, reload it into the image (`make load`, re-run
the Metacello load, or use Iceberg), otherwise the change is not reflected in
tests.

## Packages

| Package | Role |
|---------|------|
| Google-Core | HTTP/REST foundation (client, response, exception) |
| Google-Auth | GCP authentication (ADC, service-account JWT, OAuth2) |
| Google-GenAI | Gemini client and domain types (incl. function calling) |
| Google-BigQuery | BigQuery client and domain types |
| BaselineOfGoogleCloud | Metacello baseline |
| Google-*-Tests | SUnit tests (offline; no credentials required) |

## Gemini function calling (overview)

Modeled on the Python `google-genai` SDK. Declare tools with
`GeminiFunctionDeclaration` + `GeminiTool`, send via `generateContent:tools:` or
`chat:tools:`, inspect `response hasFunctionCall` / `response functionCalls`, and
reply with a `GeminiFunctionResponse`. `runConversation:tools:handlers:` runs the
whole loop automatically. For options the convenience methods do not expose
(e.g. `systemInstruction`, a custom `toolConfig`), build a `GeminiRequest` and
call `client send: aRequest`. See `docs/gemini.md` and
`.claude/rules/rest-api-patterns.md`.

Structured output: set `responseMimeType: 'application/json'` + `responseSchema:`
on a request, `send:` it, and read `response json` (controlled generation and
function calling are mutually exclusive on one request).

Errors are **signalled**, not returned: a failed request raises a `GeminiError`
(subclass of `Error`); handle with `[ ... ] on: GeminiError do: [ :e | ... ]`.

Default model: `gemini-2.5-flash` (`GoogleGenAIConfig class>>supportedModels`).

## Documentation style

- In Japanese text, do not put a space between Japanese characters and Latin
  characters (English words, code, numbers) — e.g. `Geminiで`, `第0章`.
- Do not use `→`. Express references with `：` and connections with words like
  `と` / `して`.

## Detailed rules

The rules are split into "generic (copyable to other Smalltalk projects)" and
"specific to this project". See `.claude/rules/README.md` for how they are
organized.

- Pharo syntax & naming (generic): `.claude/rules/pharo-syntax.md` (auto-loaded for `.st` files)
- REST API patterns (generic): `.claude/rules/rest-api-patterns.md` (auto-loaded for `src/Google-*/`)
- Testing conventions (generic): `.claude/rules/testing.md` (auto-loaded for `*-Tests/`)
- Project-specific conventions: `.claude/rules/project-conventions.md` (prefixes, packages, models, domain model)
- Roadmap: `ROADMAP.md`

## Conventions for writing rules files

- **Language: English.**
- **Cite sources:** point to a primary source where one exists (official docs, class comments).
- **No speculation:** record only verified facts. If a reason is unknown, write "reason unknown" or omit it.
- **Only verified code:** include code examples only for patterns that have passed local tests.
