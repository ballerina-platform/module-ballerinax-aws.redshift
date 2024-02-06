# Working with AWS Redshift

This guide explains how to create an HTTP RESTful API using Ballerina for performing basic CRUD operations on a database by connecting to AWS Redshift.

### 1. Set up

Refer to the setup guide in [ReadMe](../../../README.md) for necessary credentials.

### 2. Configuration

Configure AWS Redshift API credentials in `Config.toml` within the setup and music_store directories:

```toml
    jdbcUrl="<JDBC URL of the created Redshift cluster>"
    user="<Username>"
    password="<Password>"
```

## Run the Example

1. First, run the [`setup`](setup) ballerina program to set up the `MUSIC_STORE` database used in the sample. Execute the following command:
```bash
cd setup
bal run
```

2. Then to run the `music_store` example, execute the following command:
```bash
cd music_store
bal run
```
