# Claude Rules for google-cloud-smalltalk

Rules files in this directory are auto-loaded by Claude Code when editing files
matching the `paths:` globs in each file's frontmatter.

## Layout

| File | Scope | Reusable? |
|------|-------|-----------|
| `pharo-syntax.md` | Pharo syntax, naming, formatting, Tonel layout, Metacello baseline convention | Yes — copy as-is |
| `rest-api-patterns.md` | Patterns for wrapping an HTTP/JSON REST API (Zinc + NeoJSON: auth, request/response objects, error handling, function calling) | Yes — copy as-is (snippets use this project as a worked example) |
| `testing.md` | SUnit conventions (setUp, naming, assertions, offline stubs, JSON round-trip) | Yes — copy as-is |
| `project-conventions.md` | Everything specific to THIS project (prefixes, packages, models, domain model) | No — rewrite per project |

## Reusing in Another Smalltalk Project

1. Copy `pharo-syntax.md` and `testing.md` unchanged.
2. Copy `rest-api-patterns.md` if the project wraps an HTTP/JSON REST API.
   (For a C-library wrapper, use a `uffi-patterns.md` instead.)
3. Write a new `project-conventions.md` for the target project, covering at least:
   - class prefixes and package layout
   - custom protocol names (if any)
   - domain model and supported services/models
   - error hierarchy and authentication
4. Adjust `paths:` globs if the source layout differs from `src/<Package>/`.

## Conventions for Editing Rules Files

- Write in **English**.
- Cite primary sources where they exist (official docs, class comments).
- No speculation — record only verified facts; write "reason unknown" or omit.
- Only include code examples that have passed local tests.
