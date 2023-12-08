## Overview
The  [Ballerina](https://ballerina.io/) connector for Amazon Redshift enables you to programmatically access Amazon Redshift, a fully managed data warehouse service in the cloud. This connector leverages the Java Database Connectivity (JDBC) API to provide operations for executing Data Definition Language (DDL) commands, Structured Query Language (SQL) commands, and SQL functions to interact with Amazon Redshift. For detailed information about Amazon Redshift SQL commands, refer to the official documentation.

## Prerequisites
Before using this connector in your Ballerina application, ensure you have the following prerequisites:

### To connect to Amazon Redshift

* Create an Amazon Web Services (AWS) account.
* Set up an Amazon Redshift cluster.
* Obtain the AWS access key, secret key, and the Redshift cluster endpoint.

## Quickstart

To use the Amazon Redshift connector in your Ballerina application, follow these steps:

### Step 1: Import connector and driver
Import the following modules into the Ballerina project:
```ballerina
import ballerina/sql;
import ballerinax/aws.redshift;      // Get the AWS Redshift connector
import ballerinax/aws.redshift.driver as _;   // Get the AWS Redshift driver
```

### Step 2: Create a new connector instance
Initialize the Redshift connector by providing the necessary connection details:
```
redshift:Client dbClient = check new (jdbcUrl, <username>, <password>);
```

### Step 3: Invoke the connector operations

Following is a sample code to query data from a table.

```ballerina
   import ballerina/io;
   import ballerina/sql;
   import ballerinax/aws.redshift; // Get the AWS Redshift connector
   import ballerinax/aws.redshift.driver as _; // Get the AWS Redshift driver
   
   // Connection Configurations
   configurable string jdbcUrl = ?;
   configurable string user = ?;
   configurable string password = ?;
   
   // Initialize the Redshift client
   redshift:Client dbClient = check new (jdbcUrl, user, password);
   
   public function main() returns error? {
      sql:ParameterizedQuery sqlQuery = `SELECT * FROM Users limit 10`;
      stream<record {}, error?> resultStream = dbClient->query(sqlQuery);
      check from record {} result in resultStream
      do {
         io:println("Full details of users: ", result);
      };
   }
 ```

2. Use `bal run` command to compile and run the Ballerina program.
