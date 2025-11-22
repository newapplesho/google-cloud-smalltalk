# Getting Started

This guide explains how to set up authentication for google-cloud-smalltalk.

## Prerequisites

- Pharo 12.0 or 13.0
- A Google Cloud Platform account
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (optional, for user credentials)

## Authentication Methods

This library supports two authentication methods:

| Method | Use Case |
|--------|----------|
| Service Account | Production environments, CI/CD |
| User Credentials (ADC) | Local development |

### Option 1: Service Account (Recommended for Production)

1. Create a service account in the [Google Cloud Console](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Download the JSON key file
3. Set the environment variable:

```smalltalk
Smalltalk platform environment
    at: 'GOOGLE_APPLICATION_CREDENTIALS'
    put: '/path/to/service_account_key.json'.
```

### Option 2: Application Default Credentials (ADC)

For local development, you can use your personal Google account:

```bash
gcloud auth application-default login
```

This creates credentials at `~/.config/gcloud/application_default_credentials.json`, which the library automatically detects.

## Credential Loading Order

The library loads credentials in this order:

1. `GOOGLE_APPLICATION_CREDENTIALS` environment variable
2. `~/.config/gcloud/application_default_credentials.json`

## Verifying Authentication

```smalltalk
"Test that credentials are loaded correctly"
loader := GoogleCredentialLoader new.
credentials := loader loadApplicationDefaultCredentials.
Transcript show: 'Credential type: ', (credentials at: #type); cr.
```

## Supported Credential Types

| Type | Description |
|------|-------------|
| `service_account` | Service account JSON key |
| `authorized_user` | User credentials from gcloud CLI |

## Troubleshooting

### "Credentials file does not exist"

Ensure the file path is correct and the file exists:

```smalltalk
'/path/to/credentials.json' asFileReference exists. "Should return true"
```

### "Unsupported credential type"

The library currently supports `service_account` and `authorized_user` types only.

## Next Steps

- [Gemini AI](gemini.md) - Generate content with Gemini
- [BigQuery](bigquery.md) - Query data with BigQuery