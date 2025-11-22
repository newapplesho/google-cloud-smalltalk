# BigQuery

This guide covers using Google BigQuery with google-cloud-smalltalk.

## Quick Start

```smalltalk
client := BigQueryClient new
    projectId: 'your-gcp-project-id'.

datasets := client listDatasets.
Transcript show: datasets; cr.
```

## Configuration

```smalltalk
client := BigQueryClient new
    projectId: 'your-gcp-project-id'.
```

## Available Methods

### List Datasets

List all datasets in the project:

```smalltalk
"List all datasets (including hidden)"
datasets := client listAllDatasets.

"List datasets with visibility parameter"
datasets := client datasetsWithAllParameter: true.
```

### Get Dataset Details

Retrieve details for a specific dataset:

```smalltalk
dataset := client getDataset: 'my_dataset'.
Transcript show: dataset; cr.
```

## Response Format

Responses are returned as parsed JSON (NeoJSONObject):

```smalltalk
datasets := client listDatasets.

"Access dataset list"
(datasets at: 'datasets') do: [ :ds |
    Transcript show: (ds at: 'datasetReference' at: 'datasetId'); cr.
].
```

## Error Handling

Handle API errors gracefully:

```smalltalk
[
    dataset := client getDataset: 'non_existent_dataset'.
] on: Error do: [ :ex |
    Transcript show: 'Error: ', ex messageText; cr.
].
```

## See Also

- [Getting Started](getting-started.md) - Authentication setup
- [Gemini AI](gemini.md) - Generate content with Gemini