# Examples

The `ballerinax/aws.redshift` connector facilitates seamless integration with Amazon Redshift, offering Ballerina users a convenient and expressive way to connect, query, and interact with Redshift clusters.

1. [Read data from the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/query) - Connects to AWS Redshift using the Redshift connector and performs a simple SQL query to select all records from a specified table with a limit of 10.

2. [Insert data in to the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/execute) - Connects to AWS Redshift using the Redshift connector and performs an INSERT operation into a specified table

3. [Music store](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/music-store) -  This guide explains how to create an HTTP RESTful API using Ballerina for performing basic CRUD operations on a database by connecting to AWS Redshift.

## Prerequisites

1. Follow the [instructions](https://github.com/ballerina-platform/module-ballerinax-aws.redshift#set-up-guide) to set up the AWS Redshift cluster.

2. For each example, create a new Ballerina project. Copy the provided example code into the project, and include a `config.toml` file with the necessary JDBC URL, username, and password. Below is an example illustrating how your `config.toml` file should be structured:
    ```toml
        jdbcUrl="<JDBC URL of the created Redshift cluster>"
        user="<Username>"
        password="<Password>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```
