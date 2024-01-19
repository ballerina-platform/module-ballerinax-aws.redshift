# Query function

Connects to AWS Redshift using the Redshift connector and performs a simple SQL query to select all records from a specified table with a limit of 10.

## Prerequisites

### 1. Set up

Refer to the set up guide in [ReadMe](../../../README.md) for necessary credentials.

### 2. Configuration

Configure AWS Redshift API credentials in Config.toml in the example directory:

```toml
    jdbcUrl="<JDBC URL of the created Redshift cluster>"
    user="<Username>"
    password="<Password>"
```


## Run the Example

Execute the following command to run the example:

```bash
bal run
```
