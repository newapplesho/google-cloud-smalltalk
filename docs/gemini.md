# Gemini AI

This guide covers using Google's Gemini AI models with google-cloud-smalltalk.

## Quick Start

```smalltalk
client := GoogleGenAIClient new
    config: (GoogleGenAIConfig new
        projectId: 'your-gcp-project-id';
        location: 'global';
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
    location: 'global';  "Gemini 2.5 models are served via the global endpoint"
    useVertexAI: true;
    yourself.
```

> **Note:** On Vertex AI, the Gemini 2.5 models (`gemini-2.5-flash`,
> `gemini-2.5-pro`) are served from the **global** endpoint. Use
> `location: 'global'`; a regional location such as `us-central1` returns a
> 404/permission error for these models. When `location` is `'global'` the client
> targets `https://aiplatform.googleapis.com/`.

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
| `location` | `us-central1` | Vertex AI location; use `global` for Gemini 2.5 models |
| `useVertexAI` | `false` | Use Vertex AI endpoint |
| `apiKey` | - | API key (required if not using Vertex AI) |
| `defaultModel` | `gemini-2.5-flash` | Default model name |
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
    withModel: 'gemini-2.5-pro'.
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

## Function Calling

Gemini can ask your application to call functions (tools) you declare, then use
the results to answer. This mirrors the Python `google-genai` SDK and is the
basis for agent frameworks such as ADK.

### 1. Declare a tool

```smalltalk
weather := GeminiFunctionDeclaration
    name: 'get_weather'
    description: 'Get the current weather for a city'.
weather parameterNamed: 'city' type: 'string' description: 'City name'.
weather requiredParameters: #( 'city' ).

tool := GeminiTool withFunctionDeclaration: weather.
```

### 2. Inspect the function call (primitives)

Drive the round-trip yourself — useful when an agent framework owns the loop:

```smalltalk
conversation := GeminiConversation new.
conversation addUser: 'What is the weather in Tokyo?'.

response := client chat: conversation tools: { tool }.

response hasFunctionCall ifTrue: [
    | call result |
    call := response functionCalls first.   "GeminiFunctionCall"
    "call name -> 'get_weather', call args -> a Dictionary"
    result := Dictionary new at: 'tempC' put: 21; yourself.
    conversation addMessage: (GeminiChatMessage
        role: 'model' parts: response candidates first parts).
    conversation addFunctionResponse: call name response: result.
    response := client chat: conversation tools: { tool } ].

Transcript show: response text.
```

### 3. Automatic tool loop

`runConversation:tools:handlers:` runs the whole loop: it sends the
conversation, executes the matching handler block for each function call, appends
the results, and resends until the model produces a final answer (or a
max-iteration guard is reached).

```smalltalk
handlers := Dictionary new
    at: 'get_weather' put: [ :args |
        Dictionary new at: 'tempC' put: 21; yourself ];
    yourself.

conversation := GeminiConversation new.
conversation addUser: 'What is the weather in Tokyo?'.

response := client
    runConversation: conversation
    tools: { tool }
    handlers: handlers.
Transcript show: response text.
```

Each handler is a block taking the call's `args` Dictionary and returning a
Dictionary (any non-Dictionary result is wrapped as `{ 'result': value }`).

### Controlling tool use

Use `GeminiToolConfig` to force or disable function calls:

```smalltalk
request toolConfig: (GeminiToolConfig
    mode: 'ANY'                         "AUTO (default) | ANY | NONE"
    allowedFunctionNames: #( 'get_weather' )).
```

## System Instructions

A system instruction steers the model's overall behaviour. Set it on a request
and send it with `send:` (the convenience methods build the request for you, so
use `send:` when you need `systemInstruction`, a custom `toolConfig`, or other
options):

```smalltalk
request := GeminiRequest new
    prompt: 'Who are you?';
    systemInstruction: 'You are a helpful assistant that answers like a pirate.';
    yourself.
response := client send: request.
Transcript show: response text.
```

It works the same way on a `GeminiChatRequest` (with tools, etc.):

```smalltalk
request := GeminiChatRequest new
    conversation: conversation;
    systemInstruction: 'Always answer in one short sentence.';
    addTool: weatherTool;
    yourself.
response := client send: request.
```

## Structured Output

Constrain the model to return JSON conforming to a schema. Set
`responseMimeType: 'application/json'` and a `responseSchema` (the same
OpenAPI-subset shape as a function declaration's parameters), send with `send:`,
and read the parsed result with `GeminiResponse>>json`:

```smalltalk
schema := Dictionary new
    at: 'type' put: 'object';
    at: 'properties' put: (Dictionary new
        at: 'city'  put: (Dictionary with: 'type' -> 'string');
        at: 'tempC' put: (Dictionary with: 'type' -> 'integer');
        yourself);
    at: 'required' put: #('city' 'tempC');
    yourself.

request := GeminiRequest new
    prompt: 'Current weather for Tokyo';
    responseMimeType: 'application/json';
    responseSchema: schema;
    yourself.
response := client send: request.

data := response json.          "a Dictionary"
Transcript show: (data at: 'city').
```

> **Note:** On Vertex AI, controlled generation (structured output) and function
> calling are mutually exclusive on the same request — use one or the other.

## Error Handling

A failed request signals a `GeminiError` (a subclass of `Error`). Handle it with
`on:do:` like any Pharo exception:

```smalltalk
[ response := client generateContent: 'Hello'.
  Transcript show: response text; cr ]
    on: GeminiError
    do: [ :e |
        Transcript
            show: 'Error: ', e messageText;
            show: ' (Status: ', e statusCode printString, ')'; cr ].
```

`GeminiError` exposes `messageText` (the API message), `statusCode` (the HTTP
status), and `message`. Because it is an exception, it also composes naturally
with `ensure:` for cleanup. The automatic loop `runConversation:tools:handlers:`
propagates the same exception, so wrap the whole call in one `on: GeminiError`.

## Available Models

`GoogleGenAIConfig class>>supportedModels` is the source of truth.

| Model | Description |
|-------|-------------|
| `gemini-2.5-flash` | Fast, function-calling capable (default) |
| `gemini-2.5-pro` | Most capable |
| `gemini-2.0-flash` | Previous-generation flash |

## Tips

- Always add the model's response to the conversation with `addModel:` to maintain context
- Use Vertex AI for production workloads
- Set appropriate timeouts for long-running requests

## See Also

- [Getting Started](getting-started.md) - Authentication setup
- [BigQuery](bigquery.md) - Query data with BigQuery