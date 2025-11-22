# BigQuery

This guide covers using Google BigQuery with google-cloud-smalltalk.

## Quick Start

```smalltalk
client := BigQueryClient new
    projectId: 'your-gcp-project-id'.

"Execute a query"
result := client query: 'SELECT * FROM `dataset.table` LIMIT 10'.
result rows do: [ :row | Transcript show: row; cr ].

"List datasets"
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

### Execute Query

Execute a SQL query:

```smalltalk
"Simple query"
result := client query: 'SELECT name, age FROM `project.dataset.users` LIMIT 10'.

"Query with settings"
result := client
    query: 'SELECT * FROM `project.dataset.table`'
    settings: (BigQueryQuerySettings new
        maxResults: 100;
        timeoutMs: 30000;
        yourself).

"Dry run (validate query without executing)"
result := client
    query: 'SELECT * FROM `project.dataset.table`'
    settings: (BigQueryQuerySettings new dryRun; yourself).
```

## BigQueryQuerySettings

Configure query execution settings:

```smalltalk
settings := BigQueryQuerySettings new.

"Validate query without executing"
settings dryRun.

"Limit number of results"
settings maxResults: 100.

"Set timeout in milliseconds"
settings timeoutMs: 30000.

"Use Legacy SQL (not recommended)"
settings useLegacySql.
```

## BigQueryQueryResponse

Query results are returned as `BigQueryQueryResponse`:

```smalltalk
result := client query: 'SELECT name, age FROM `dataset.users`'.

"Access rows as Dictionaries"
result rows do: [ :row |
    Transcript
        show: (row at: 'name');
        show: ' - ';
        show: (row at: 'age');
        cr ].

"Check result metadata"
result totalRows.           "Total number of rows"
result jobComplete.         "Whether query completed"
result cacheHit.            "Whether result was cached"
result totalBytesProcessed. "Bytes processed"

"Pagination"
result hasMorePages.        "Check if more pages exist"
result pageToken.           "Token for next page"

"Job information"
result jobId.               "Job ID"
result queryId.             "Query ID"

"DML operations"
result numDmlAffectedRows.  "Rows affected by DML"
result dmlStats.            "DML statistics"

"Error handling"
result hasErrors.           "Check for errors"
result errors.              "Error details"

"Convenience methods"
result isEmpty.             "Check if no rows returned"
result do: [ :row | ... ].  "Iterate over rows"
result collect: [ :row | ... ]. "Transform rows"
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