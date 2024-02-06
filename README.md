Ballerina AWS Redshift Connector
===================

[![Build](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/trivy-scan.yml)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-aws.redshift/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-aws.redshift)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-aws.redshift.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/commits/main)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/build-with-bal-test-graalvm.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Amazon Redshift](https://aws.amazon.com/redshift/) is a powerful and fully-managed data warehouse service provided by Amazon Web Services (AWS), designed to efficiently analyze large datasets with high performance and scalability.

The `ballerinax/aws.redshift` connector facilitates seamless integration with Amazon Redshift, offering Ballerina users a convenient and expressive way to connect, query, and interact with Redshift clusters, utilizing the AWS Redshift JDBC driver available through [`ballerinax/aws.redshift.driver`](https://central.ballerina.io/ballerinax/aws.redshift.driver/latest).

## Set up guide

To effectively utilize the Ballerina AWS Redshift connector, you must have an Amazon Redshift cluster. Follow these steps to create an AWS Redshift cluster.

### Step 1: Login to AWS Console
1. Begin by logging into the [AWS Management Console](https://aws.amazon.com/).

### Step 2: Navigate to Amazon Redshift and Create a Cluster
1. In the AWS Console, navigate to the Amazon Redshift service. Click on the "Create cluster" button to initiate the process of creating a new Amazon Redshift cluster.

    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/create-cluster-1.png alt="Create cluster" width="50%">
   
    <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/create-cluster-2.png alt="Create cluster" width="50%">

### Step 3: Configure Cluster Settings
1. Follow the on-screen instructions to configure your Redshift cluster settings, including cluster identifier, database name, credentials, and other relevant parameters.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/basic-configs.png alt="Basic configs" width="50%">
   
2. Configure security groups to control inbound and outbound traffic to your Redshift cluster. Ensure that your Ballerina application will have the necessary permissions to access the cluster.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/security-configs.png alt="Security configs" width="50%">
   
3. Record the username and password you set during the cluster configuration. These credentials will be used to authenticate your Ballerina application with the Redshift cluster.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/credentials.png alt="Credentials" width="50%">
   
4. Finally, review your configuration settings, and once satisfied, click "Create cluster" to launch your Amazon Redshift cluster.

### Step 4: Wait for Cluster Availability
1. It may take some time for your Redshift cluster to be available. Monitor the cluster status in the AWS Console until it shows as "Available".

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/availability.png alt="Availability" width="50%">
   
2. After the cluster is successfully created, copy the JDBC URL. You can find this information in the cluster details or configuration section of the AWS Console.

   <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/jdbc-url.png alt="JDBC URL" width="50%">

## Quickstart

To use the `aws.redshift` connector in your Ballerina application, modify the `.bal` file as follows:

### Step 1: Import the connector

Import the `ballerinax/aws.redshift` package and the `ballerinax/aws.redshift.driver` into your Ballerina project.

```ballerina
import ballerinax/aws.redshift; // Get the AWS Redshift connector
import ballerinax/aws.redshift.driver as _; // Get the AWS Redshift driver
```

### Step 2: Instantiate a new client

Create a `redshift:Client` with the values obtained in the previous steps.

```ballerina
// Connection Configurations
configurable string jdbcUrl = ?;
configurable string user = ?;
configurable string password = ?;

// Initialize the Redshift client
redshift:Client dbClient = check new (jdbcUrl, user, password);
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Read data from the database

```ballerina
// Create the result record to match the columns of the table being queried.
type User record {|
    string name;
    string email;
    string state;
|};

sql:ParameterizedQuery sqlQuery = `SELECT * FROM Users limit 10`;
stream<User, error?> resultStream = dbClient->query(sqlQuery);
check from User user in resultStream
   do {
      io:println("Full details of users: ", user);
   };
```

#### Insert data into the database
```ballerina
sql:ParameterizedQuery sqlQuery = `INSERT INTO your_table_name (firstname, lastname, state, email, username)
   VALUES ('Cody', 'Moss', 'ON', 'dolor.nonummy@ipsumdolorsit.ca', 'WWZ18EOX');`;
_ = check dbClient->execute(sqlQuery);
```

## Examples

The `aws.redshift` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/tree/master/examples).

1. [Read data from the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/query) - Connects to AWS Redshift using the Redshift connector and performs a simple SQL query to select all records from a specified table with a limit of 10.

2. [Insert data in to the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/execute) - Connects to AWS Redshift using the Redshift connector and performs an INSERT operation into a specified table

3. [Music store](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/music-store) - This example illustrates the process of creating an HTTP RESTful API with Ballerina to perform basic CRUD operations on a database, specifically AWS Redshift, involving setup, configuration, and running examples.

## Issues and projects

The **Issues** and **Projects** tabs are disabled for this repository as this is part of the Ballerina library. To report bugs, request new features, start new discussions, view project boards, etc., visit the Ballerina library [parent repository](https://github.com/ballerina-platform/ballerina-library).

This repository only contains the source code for the package.

## Build from the source

### Prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To debug package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

5. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

6. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

7. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`aws.redshift` package](https://lib.ballerina.io/ballerinax/aws.redshift/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
