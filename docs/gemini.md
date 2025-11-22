# Gemini AI

This guide covers using Google's Gemini AI models with google-cloud-smalltalk.

## Quick Start

```smalltalk
client := GoogleGenAIClient new
    config: (GoogleGenAIConfig new
        projectId: 'your-gcp-project-id';
        useVertexAI: true;
        yourself).

response := client generateContent: 'Explain Smalltalk in one sentence.'.
Transcript show: response text.
```

## Configuration Options

### Using Vertex AI (Recommended)

Vertex AI provides enterprise features and regional endpoints:

```smalltalk
config := GoogleGenAIConfig new
    projectId: 'your-gcp-project-id';
    location: 'us-central1';  "Optional, defaults to us-central1"
    useVertexAI: true;
    yourself.
```

### Using API Key

For simple use cases without Google Cloud project:

```smalltalk
config := GoogleGenAIConfig new
    apiKey: 'your-api-key';
    useVertexAI: false;
    yourself.
```

### Configuration Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `projectId` | - | GCP project ID (required for Vertex AI) |
| `location` | `us-central1` | Vertex AI region |
| `useVertexAI` | `false` | Use Vertex AI endpoint |
| `apiKey` | - | API key (required if not using Vertex AI) |
| `defaultModel` | `gemini-2.0-flash-001` | Default model name |
| `timeout` | `30` | Request timeout in seconds |

## Basic Text Generation

### Simple Prompt

```smalltalk
response := client generateContent: 'What is Smalltalk?'.
Transcript show: response text.
```

### Specifying a Model

```smalltalk
response := client
    generateContent: 'Explain polymorphism'
    withModel: 'gemini-1.5-pro'.
Transcript show: response text.
```

## Chat Conversations

For multi-turn conversations, use `GeminiConversation`:

```smalltalk
conversation := GeminiConversation new.

"First message"
conversation addUser: 'Who created Smalltalk?'.
response := client chat: conversation.
conversation addModel: response text.
Transcript show: response text; cr.

"Follow-up"
conversation addUser: 'What year was it created?'.
response := client chat: conversation.
conversation addModel: response text.
Transcript show: response text; cr.
```

## Code Generation

Generate Smalltalk code with Gemini:

```smalltalk
conversation := GeminiConversation new.

conversation addUser: 'Create a Smalltalk class called TodoItem with instance variables: title, description, completed. Output only the class definition.'.
response := client chat: conversation.

"Clean and evaluate the generated code"
cleanCode := (response text copyReplaceAll: '```smalltalk' with: '')
    copyReplaceAll: '```' with: ''.

[
    Smalltalk compiler evaluate: cleanCode.
    Transcript show: 'Class created successfully!'; cr.
] on: Error do: [ :ex |
    Transcript show: 'Error: ', ex messageText; cr.
].
```

## Error Handling

The client returns `GeminiError` for failed requests:

```smalltalk
response := client generateContent: 'Hello'.

(response isKindOf: GeminiError)
    ifTrue: [
        Transcript
            show: 'Error: ', response message;
            show: ' (Status: ', response statusCode asString, ')'; cr ]
    ifFalse: [
        Transcript show: response text; cr ].
```

## Available Models

| Model | Description |
|-------|-------------|
| `gemini-2.0-flash-001` | Fast, efficient (default) |
| `gemini-1.5-pro` | Most capable |
| `gemini-1.5-flash` | Balanced speed/quality |

## Tips

- Always add the model's response to the conversation with `addModel:` to maintain context
- Use Vertex AI for production workloads
- Set appropriate timeouts for long-running requests

## See Also

- [Getting Started](getting-started.md) - Authentication setup
- [BigQuery](bigquery.md) - Query data with BigQuery