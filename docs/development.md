# Development

How to work on google-cloud-smalltalk itself (a Pharo / Tonel project).

## Prerequisites

- macOS or Linux (Windows: load manually in the Pharo UI — see below)
- `make`, `curl`, `bash`

## One-time setup

Download a local Pharo image + VM into `pharo-local/` (git-ignored):

```bash
make setup
```

This fetches Pharo 13 via `get.pharo.org`. To use a different version, override
`PHARO_VERSION` (e.g. `make setup PHARO_VERSION=120`).

## Daily cycle

```bash
make load    # load (or reload) the project into pharo-local/Pharo.image
make test    # run all tests headless (JUnit XML), pattern Google.*
make ui      # open the Pharo GUI on the loaded image
make help    # list targets
```

Tonel `.class.st` files are **not live** until re-imported. After editing source,
run `make load` again (or reload via Iceberg in the UI) before `make test`.

- `scripts/load-project.st` is the **single source of truth** for the Metacello
  load expression. Paste it into a Playground and press Ctrl+D to load manually
  (this is also the Windows path).
- `scripts/run-tests.st` runs the suite and prints a summary to the Transcript
  (handy inside the UI).

## Loading without the Makefile

In a Playground (any platform):

```smalltalk
Metacello new
    baseline: 'GoogleCloud';
    repository: 'github://newapplesho/google-cloud-smalltalk:main/src';
    load.
```

For a working copy, replace the repository with your local checkout:
`'tonel://', '<repository root>/src'`.

## Project layout

| Package | Role |
|---------|------|
| Google-Core | HTTP/REST foundation (`GoogleHttpClient`, `GoogleAPIClient`, `GoogleRestResponse`, `GoogleRestException`) |
| Google-Auth | Authentication (ADC, service-account JWT, OAuth2, token caching) |
| Google-GenAI | Gemini client and domain types (incl. function calling) |
| Google-BigQuery | BigQuery client and domain types |
| BaselineOfGoogleCloud | Metacello baseline |
| Google-*-Tests | SUnit tests (offline; no credentials / no network) |

New classes go into the existing packages — no baseline edit needed. The
`.smalltalk.ston` test spec matches `Google-*`, so new test classes are picked up
automatically.

## Tests

Unit tests are **offline**: they use JSON fixtures and `GeminiStubClient` (a
`GoogleGenAIClient` subclass that returns canned responses), so no GCP
credentials are required and CI runs with no network.

A live, credentialed check is **not** part of the suite. To run one manually, set
`GOOGLE_APPLICATION_CREDENTIALS` and call the client against a real project (see
[docs/gemini.md](gemini.md)).

## CI

`.github/workflows/ci.yml` runs smalltalkCI on Pharo 12 and 13:

```bash
smalltalkci -s Pharo64-13 .smalltalk.ston
```

## Coding conventions

See [`.claude/rules/`](../.claude/rules/) — `pharo-syntax.md` (generic Pharo /
Tonel style), `rest-api-patterns.md` (Zinc + NeoJSON request/response patterns),
`testing.md`, and `project-conventions.md` (this project's prefixes, packages,
models, and domain model). These are auto-loaded by Claude Code when editing.
