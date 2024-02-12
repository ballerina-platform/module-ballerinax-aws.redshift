## Package overview

[Amazon Redshift](https://aws.amazon.com/redshift/) is a powerful and fully-managed data warehouse service provided by Amazon Web Services (AWS), designed to efficiently analyze large datasets with high performance and scalability.

The `ballerinax/aws.redshift` connector facilitates seamless integration with Amazon Redshift, offering Ballerina users a convenient and expressive way to connect, query, and interact with Redshift clusters.

## Setup guide

To effectively utilize the Ballerina AWS Redshift connector, you must have an Amazon Redshift cluster. Follow these steps to create an AWS Redshift cluster.

### Step 1: Login to AWS console

1. Begin by logging into the [AWS Management Console](https://aws.amazon.com/).

### Step 2: Navigate to Amazon Redshift and create a cluster

1. In the AWS Console, navigate to the Amazon Redshift service. Click on the "Create cluster" button to initiate the process of creating a new Amazon Redshift cluster.

   ![Create cluster](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/create-cluster-1.png)

   ![Create cluster](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/create-cluster-2.png)

### Step 3: Configure cluster settings

1. Follow the on-screen instructions to configure your Redshift cluster settings, including cluster identifier, database name, credentials, and other relevant parameters.

   ![Basic configs](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/basic-configs.png)

2. Configure security groups to control inbound and outbound traffic to your Redshift cluster. Ensure that your Ballerina application will have the necessary permissions to access the cluster.

   ![Security configs](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/security-configs.png)

3. Record the username and password you set during the cluster configuration. These credentials will be used to authenticate your Ballerina application with the Redshift cluster.

   ![Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/credentials.png)

4. Finally, review your configuration settings, and once satisfied, click "Create cluster" to launch your Amazon Redshift cluster.

### Step 4: Wait for cluster availability

1. It may take some time for your Redshift cluster to be available. Monitor the cluster status in the AWS Console until it shows as "Available".

   ![Availability](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/availability.png)

2. After the cluster is successfully created, copy the JDBC URL. You can find this information in the cluster details or configuration section of the AWS Console.

   ![JDBC URL](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-aws.redshift/master/docs/setup/resources/jdbc-url.png)

## Quickstart

To use the `aws.redshift` connector in your Ballerina application, modify the `.bal` file as follows:

### Step 1: Import the connector

Import the `ballerinax/aws.redshift` package and the `ballerinax/aws.redshift.driver` package.

```ballerina
import ballerinax/aws.redshift; 
import ballerinax/aws.redshift.driver as _; 
```

### Step 2: Instantiate a new client

Create a `redshift:Client` with the values obtained in the previous steps.

```ballerina
configurable string jdbcUrl = ?;
configurable string user = ?;
configurable string password = ?;

redshift:Client redshift = check new (jdbcUrl, user, password);
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Read data from the database

```ballerina
type User record {|
    string name;
    string email;
    string state;
|};

sql:ParameterizedQuery sqlQuery = `SELECT * FROM Users limit 10`;
stream<User, error?> resultStream = redshift->query(sqlQuery);
check from User user in resultStream
   do {
      io:println("Full details of users: ", user);
   };
```

#### Insert data into the database
```ballerina
sql:ParameterizedQuery sqlQuery = `INSERT INTO your_table_name (firstname, lastname, state, email, username)
   VALUES ('Cody', 'Moss', 'ON', 'dolor.nonummy@ipsumdolorsit.ca', 'WWZ18EOX');`;
_ = check redshift->execute(sqlQuery);
```

## Examples

The `aws.redshift` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/tree/master/examples).

1. [Read data from the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/query) - Connects to AWS Redshift using the Redshift connector and performs a simple SQL query to select all records from a specified table with a limit of 10.

2. [Insert data in to the database](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/execute) - Connects to AWS Redshift using the Redshift connector and performs an INSERT operation into a specified table

3. [Music store](https://github.com/ballerina-platform/module-ballerinax-aws.redshift/blob/main/examples/music-store) - This example illustrates the process of creating an HTTP RESTful API with Ballerina to perform basic operations on a database, specifically AWS Redshift, involving setup, configuration, and running examples.

## Report issues
To report bugs, request new features, start new discussions, view project boards, etc., go to the [Ballerina Extended Library repository](https://github.com/ballerina-platform/ballerina-library)

## Useful links
- Discuss code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag
