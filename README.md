# google-cloud-smalltalk

[![ci](https://github.com/newapplesho/google-cloud-smalltalk/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/newapplesho/google-cloud-smalltalk/actions/workflows/ci.yml)

Pharo Smalltalk client libraries for [Google Cloud Platform](https://cloud.google.com/) services.

## Disclaimer

This is an **unofficial**, community-maintained library and is **not** affiliated with, endorsed, or supported by Google LLC. Use at your own risk.

## Features

| Package | Description | Documentation |
|---------|-------------|---------------|
| Google-GenAI | Gemini AI text generation and chat | [docs/gemini.md](docs/gemini.md) |
| Google-BigQuery | BigQuery dataset management | [docs/bigquery.md](docs/bigquery.md) |
| Google-Auth | GCP authentication | [docs/getting-started.md](docs/getting-started.md) |

## Requirements

| Smalltalk | Version |
|-----------|---------|
| [Pharo](http://pharo.org/) | 12.0, 13.0 |

## Installation

```smalltalk
Metacello new
  baseline: 'GoogleCloud';
  repository: 'github://newapplesho/google-cloud-smalltalk:main/src';
  load.
```

## Quick Start

### 1. Set up authentication

```smalltalk
Smalltalk platform environment at: 'GOOGLE_APPLICATION_CREDENTIALS' put:(FileLocator home / 'service_account_key.json') pathString.
```

See [Getting Started](docs/getting-started.md) for more authentication options.

### 2. Use Gemini AI

```smalltalk
client := GoogleGenAIClient new
    config: (GoogleGenAIConfig new
        projectId: 'your-gcp-project-id';
        useVertexAI: true;
        yourself).

response := client generateContent: 'Explain Smalltalk in one sentence.'.
Transcript show: response text.
```

See [Gemini Documentation](docs/gemini.md) for chat, code generation, and more.

## Documentation

- [Getting Started](docs/getting-started.md) - Authentication setup
- [Gemini AI](docs/gemini.md) - Text generation and chat
- [BigQuery](docs/bigquery.md) - Dataset management
