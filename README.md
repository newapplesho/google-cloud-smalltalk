# google-cloud-smalltalk [![ci](https://github.com/newapplesho/google-cloud-smalltalk/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/newapplesho/google-cloud-smalltalk/actions/workflows/ci.yml)

Pharo Smalltalk client libraries for [Google Cloud Platform](https://cloud.google.com/) services.

## IMPORTANT DISCLAIMER - UNOFFICIAL LIBRARY

This is an UNOFFICIAL, community-maintained library and is NOT affiliated with, endorsed, or supported by Google LLC.

- Not an official Google product
- No official support or warranties
- Not maintained by Google
- Use at your own risk

Google Cloud and all related trademarks are property of Google LLC. This library is provided "AS IS" without warranty of any kind.
For production use, we strongly recommend using the [official Google Cloud Client Libraries](https://cloud.google.com/apis/docs/cloud-client-libraries).

## Installation

```
Metacello new
  baseline: 'GoogleCloud';
  repository: 'github://newapplesho/google-cloud-smalltalk:main/src';
  load.
```

## Supported Smalltalk Versions

| Name                                 | Smalltalk Version | Version        |
| ------------------------------------ | ----------------- | -------------- |
| [Pharo Smalltalk](http://pharo.org/) | 12.0, 13.0        | Latest Version |

## Quickstart

```smalltalk
Smalltalk platform environment at: 'GOOGLE_APPLICATION_CREDENTIALS' put:(FileLocator home / 'service_account_key.json') pathString.
```

### Gemini

Basic text generation.

```smalltalk
client := GoogleGenAIClient new
    config: (GoogleGenAIConfig new
        projectId: 'your-gcp-project-id';
        useVertexAI: true;
        yourself).

"Ask Gemini to explain Smalltalk's elegance"
response := client generateContent: 'What happens when you send the message #+ to the number 2 with argument 3 in Smalltalk?'.
Transcript show: response text.
```

Chat conversation.

```smalltalk
conversation := GeminiConversation new.

conversation addUser: 'Who created Smalltalk and what was their main inspiration?'.
response := client chat: conversation.
conversation addModel: response text.
Transcript show: 'Gemini: ', response text; cr.

conversation addUser: 'Tell me about the famous "doing a Smalltalk" demo at Xerox PARC'.
response := client chat: conversation.
conversation addModel: response text.
Transcript show: 'Gemini: ', response text; cr.
```

Code generation with Smalltalk.

````smalltalk
conversation := GeminiConversation new.

"Generate class definition"
conversation addUser: 'Create a Smalltalk class called TodoItem with instance variables: title, description, completed, dueDate. Output only the class definition line.'.
response := client chat: conversation.
conversation addModel: response text.

classCode := response text.
Transcript show: 'AI generated class: ', classCode; cr.

"Attempt to create the class with AI-generated code"
[
    "Try to parse and use the AI-generated class definition"
    cleanClassCode := (classCode copyReplaceAll: '```smalltalk' with: '') copyReplaceAll: '```' with: ''.
    Smalltalk compiler evaluate: cleanClassCode.

    Transcript show: 'SUCCESS: TodoItem class created with AI code!'; cr.

    "Test the created class"
    todo := TodoItem new.
    Transcript show: 'TodoItem instance created successfully!'; cr.

] on: Error do: [ :ex |
    Transcript show: ex; cr.
].
````
