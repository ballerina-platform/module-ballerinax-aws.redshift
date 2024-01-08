Ballerina AWS Redshift Connector
===================

[![Build](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/workflows/CI/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions?query=workflow%3ACI)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/trivy-scan.yml)
[![codecov](https://codecov.io/gh/ballerina-platform/module-ballerinax-aws.redshift/branch/main/graph/badge.svg)](https://codecov.io/gh/ballerina-platform/module-ballerinax-aws.redshift)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-aws.redshift.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/commits/main)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/build-with-bal-test-native.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/actions/workflows/build-with-bal-test-native.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Amazon Redshift](https://aws.amazon.com/redshift/) is a powerful and fully-managed data warehouse service provided by Amazon Web Services (AWS), designed to efficiently analyze large datasets with high performance and scalability.

The `ballerinax/aws.redshift` connector facilitates seamless integration with Amazon Redshift, offering Ballerina users a convenient and expressive way to connect, query, and interact with Redshift clusters. 

## Set up guide

To effectively utilize the Ballerina AWS Redshift connector, you must have an Amazon Redshift cluster. Follow these steps to create an AWS Redshift cluster.

### Step 1: Login to AWS Console
1. Begin by logging into the [AWS Management Console](https://aws.amazon.com/).

### Step 2: Navigate to Amazon Redshift and Create a Cluster
1. In the AWS Console, navigate to the Amazon Redshift service. Click on the "Create cluster" button to initiate the process of creating a new Amazon Redshift cluster.
    <img src=docs/setup/resources/create-cluster-1.png alt="Create cluster" width="50%">
    <img src=docs/setup/resources/create-cluster-2.png alt="Create cluster" width="50%">

### Step 3: Configure Cluster Settings
1. Follow the on-screen instructions to configure your Redshift cluster settings, including cluster identifier, database name, credentials, and other relevant parameters.
   <img src=docs/setup/resources/create-cluster-3.png alt="Create cluster" width="50%">
2. Configure security groups to control inbound and outbound traffic to your Redshift cluster. Ensure that your Ballerina application will have the necessary permissions to access the cluster.
   <img src=docs/setup/resources/create-cluster-5.png alt="Create cluster" width="50%">
3. Record the username and password you set during the cluster configuration. These credentials will be used to authenticate your Ballerina application with the Redshift cluster.
   <img src=docs/setup/resources/create-cluster-4.png alt="Create cluster" width="50%">
4. Finally, review your configuration settings, and once satisfied, click "Create cluster" to launch your Amazon Redshift cluster.

### Step 4: Wait for Cluster Availability
1. It may take some time for your Redshift cluster to be available. Monitor the cluster status in the AWS Console until it shows as "Available".
   <img src=docs/setup/resources/create-cluster-7.png alt="Create cluster" width="50%">
2. After the cluster is successfully created, copy the JDBC URL. You can find this information in the cluster details or configuration section of the AWS Console.
   <img src=docs/setup/resources/create-cluster-8.png alt="Create cluster" width="50%">

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
sql:ParameterizedQuery sqlQuery = `SELECT * FROM Users limit 10`;
stream<record {}, error?> resultStream = dbClient->query(sqlQuery);
check from record {} result in resultStream
   do {
      io:println("Full details of users: ", result);
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
