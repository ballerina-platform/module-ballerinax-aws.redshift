# Specification: Ballerina AWS Redshift Library

_Owners_: @aashikam
_Reviewers_: @niveathika  
_Created_: 2024/01/31   
_Updated_: 2024/01/31  
_Edition_: Swan Lake

## Introduction

This is the specification for the AWS Redshift standard library of [Ballerina language](https://ballerina.io/), which the functionality required to access and manipulate data stored in a AWS Redshift database.

The AWS Redshift library specification may evolve in the future. The released versions of the specification can be found under the relevant GitHub tag.

If you have any feedback or suggestions about the library, start a discussion via a [GitHub issue](https://github.com/ballerina-platform/ballerina-library/issues) or in the [Discord server](https://discord.gg/ballerinalang). Based on the outcome of the discussion, the specification and implementation can be updated. Community feedback is always welcome. Any accepted proposal, which affects the specification is stored under `/docs/proposals`. Proposals under discussion can be found with the label `type/proposal` in GitHub.

The conforming implementation of the specification is released to Ballerina Central. Any deviation from the specification is considered a bug.

## Contents

1. [Overview](#1-overview)
2. [Client](#2-client)  
   2.1. [Handle connection pools](#21-handle-connection-pools)  
   2.2. [Close the client](#22-close-the-client)
3. [Queries and values](#3-queries-and-values)
4. [Database operations](#4-database-operations)

# 1. Overview

This specification elaborates on the usage of the AWS Redshift `Client` interface to interact with a AWS Redshift database.

`redshift:Client` supports five database operations as follows,
1. Executes the query, which may return multiple results.
2. Executes the query, which is expected to return at most one row of the result.
3. Executes the SQL query. Only the metadata of the execution is returned.
4. Executes the SQL query with multiple sets of parameters in a batch. Only the metadata of the execution is returned.
5. Executes a SQL query, which calls a stored procedure. This can either return results or nil.

All the above operations make use of `sql:ParameterizedQuery` object, backtick surrounded string template to pass SQL statements to the database.

# 2. Client

Each client represents a pool of connections to the database. The pool of connections is maintained throughout the lifetime of the client.

**Initialization of the Client:**
```ballerina
    # Initializes AWS Redshift client.
    #
    # + url - The JDBC URL of the database
    # + user - If the database is secured, the username of the database
    # + password - The password of the provided username of the database
    # + options - The database-specific JDBC client properties
    # + connectionPool - The sql:ConnectionPool object to be used within the JDBC client. 
    # If there is no connectionPool provided, the global connection pool will be used and 
    # it will be shared by other clients, which have the same properties
    # + return - Possible error when creating the client
    public isolated function init(string url, string user, string password,
        Options? options = (), sql:ConnectionPool? connectionPool = ()) returns sql:Error? {}
```

**Configurations available for initializing the AWS Redshift client:**

* Connection properties:

```ballerina
    # An additional set of configurations for the JDBC Client to be passed internally within the module.
    #
    # + url - The JDBC URL to be used for the database connection
    # + user - If the database is secured, the username
    # + password - The password of the database associated with the provided username
    # + options - The JDBC client properties
    # + connectionPool - The `sql:ConnectionPool` to be used for the connection. If there is no `connectionPool` provided,
    # the global connection pool (shared by all clients) will be used
    type ClientConfiguration record {|
        string? url;
        string? user;
        string? password;
        Options? options;
        sql:ConnectionPool? connectionPool;
    |};
```
* Additional properties:

```ballerina
    # An additional set of configurations related to a database connection.
    #
    # + datasourceName - The driver class name to be used to get the connection
    # + properties - The database properties, which should be applied when getting the connection
    # + sslMode - Value for the SSL mode
    public type Options record {|
        string? datasourceName = ();
        map<anydata>? properties = ();
        SslMode sslMode = DISABLE;
    |};
```

* SSL support
```ballerina
    # Possible values for the SSL mode.
    public enum SslMode {
        # SSL is disabled and the connection is not encrypted
        DISABLE,
        # SSL is enabled and the server certificate must be verified
        VERIFY_CA,
        # SSL is enabled. The server certificate must be verified and the server hostname must match the hostname attribute on the certificate
        VERIFY_FULL
    }
```

## 2.1. Handle connection pools

Connection pool handling is generic and implemented through `sql` module. For more information, see the
[SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#21-connection-pool-handling)

## 2.2. Close the client

Once all the database operations are performed, the client can be closed by invoking the `close()` operation. This will close the corresponding connection pool if it is not shared by any other database clients.

```ballerina
    # Closes the client and shuts down the connection pool.
    #
    # + return - Possible error when closing the client
    public isolated function close() returns sql:Error? = @java:Method {} 
```

# 3. Queries and values

All the generic `sql` Queries and Values are supported. For more information, see the
[SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#3-queries-and-values)

# 4. Database operations

`redshift:Client` supports five database operations as follows,
1. Executes the query, which may return multiple results.
2. Executes the query, which is expected to return at most one row of the result.
3. Executes the SQL query. Only the metadata of the execution is returned.
4. Executes the SQL query with multiple sets of parameters in a batch. Only the metadata of the execution is returned.
5. Executes a SQL query, which calls a stored procedure. This can either return results or nil.

For more information on database operations, see the [SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#4-database-operations)
