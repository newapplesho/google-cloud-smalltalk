# Contributing to google-cloud-smalltalk

Thanks for your interest in contributing! This project is an **unofficial**,
community-maintained set of Pharo Smalltalk client libraries for Google Cloud
Platform. Contributions of all kinds are welcome: bug reports, documentation,
tests, and code.

By contributing, you agree that your contributions will be licensed under the
project's [Apache License 2.0](LICENSE).

## Ways to contribute

- **Report a bug** or **request a feature** by opening an [issue](https://github.com/newapplesho/google-cloud-smalltalk/issues).
- **Improve the docs** in [`docs/`](docs/) or the `README`.
- **Submit code** via a pull request (see below).

Before starting substantial work, please open an issue to discuss it — this
avoids duplicated effort and keeps changes aligned with the
[Roadmap](ROADMAP.md).

## Reporting issues

When filing a bug, please include:

- What you did and what you expected to happen.
- The actual result (error messages, stack traces).
- Your Pharo version (12.0 or 13.0) and OS.
- A minimal code snippet that reproduces the problem, if possible.

Do **not** include credentials, service-account keys, or other secrets in
issues or pull requests.

## Development setup

This is a Pharo / [Tonel](https://github.com/pharo-vcs/tonel) project. With a
local Pharo image (`make setup`):

```bash
make setup   # one-time: download Pharo 13 image + VM into pharo-local/
make load    # load (or reload) the project into the image
make test    # run the offline test suite (pattern Google.*)
make ui      # open the Pharo GUI
```

Tonel `.class.st` files are **not live** until re-imported — run `make load`
again after editing source, before `make test`.

See [docs/development.md](docs/development.md) for the full workflow (loading
without the Makefile, project layout, CI).

## Coding conventions

Please follow the conventions documented in [`.claude/rules/`](.claude/rules/):

- [`pharo-syntax.md`](.claude/rules/pharo-syntax.md) — Pharo syntax, naming,
  formatting, and Tonel layout.
- [`rest-api-patterns.md`](.claude/rules/rest-api-patterns.md) — Zinc + NeoJSON
  request/response and error-handling patterns.
- [`testing.md`](.claude/rules/testing.md) — SUnit conventions.
- [`project-conventions.md`](.claude/rules/project-conventions.md) — class
  prefixes, packages, supported models, and the domain model.

New classes go into the existing `Google-*` packages — no baseline edit needed.

## Tests

Unit tests are **offline**: they use JSON fixtures and stub clients (e.g.
`GeminiStubClient`), so no GCP credentials or network access are required.

- Add or update tests for any behavior you change.
- Run `make test` and make sure the whole suite passes before opening a PR.

## Pull requests

1. Fork the repository and create a topic branch from `main`.
2. Make your change, keeping it focused — one logical change per PR.
3. Add or update tests and documentation as needed.
4. Run `make test` locally.
5. Write clear commit messages. This project uses
   [Conventional Commits](https://www.conventionalcommits.org/) (e.g. `fix:`,
   `feat:`, `docs:`, `chore:`, `ci:`).
6. Open a pull request against `main` describing the change and linking any
   related issue. CI must pass (smalltalkCI on Pharo 12 and 13).

## Questions

If anything is unclear, open an issue — questions are welcome.
