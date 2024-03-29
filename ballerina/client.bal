// Copyright (c) 2023 WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;
import ballerina/sql;

@display {label: "Redshift", iconPath: "icon.png"}
public isolated client class Client {
    *sql:Client;

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
        Options? options = (), sql:ConnectionPool? connectionPool = ()) returns sql:Error? {
        ClientConfiguration clientConf = {
            url,
            user,
            password,
            options,
            connectionPool
        };
        return createClient(self, clientConf, sql:getGlobalConnectionPool());
    }

    # Queries the database with the provided query and returns the result as a stream.
    #
    # + sqlQuery - The SQL query such as `SELECT * from Album WHERE name=${albumName}`
    # + rowType - The typedesc of the record to which the result needs to be returned
    # + return - Stream of records in the type of rowType
    remote isolated function query(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>)
    returns stream<rowType, sql:Error?> = @java:Method {
        'class: "io.ballerina.lib.aws.redshift.nativeimpl.QueryProcessor",
        name: "nativeQuery"
    } external;

    # Executes the query, which is expected to return at most one row of the result. 
    # If the query does not return any results, an sql:NoRowsError is returned.
    #
    # + sqlQuery - The SQL query such as `SELECT * from Album WHERE name=${albumName}`
    # + returnType - The typedesc of the record to which the result needs to be returned. 
    # It can be a basic type if the query result contains only one column
    # + return - Result in the returnType type or an sql:Error
    remote isolated function queryRow(sql:ParameterizedQuery sqlQuery, typedesc<anydata> returnType = <>)
    returns returnType|sql:Error = @java:Method {
        'class: "io.ballerina.lib.aws.redshift.nativeimpl.QueryProcessor",
        name: "nativeQueryRow"
    } external;

    # Executes the SQL query. Only the metadata of the execution is returned (not the results from the query).
    #
    # + sqlQuery - The SQL query such as `DELETE FROM Album WHERE artist=${artistName}`
    # + return - Metadata of the query execution as an sql:ExecutionResult or an sql:Error
    remote isolated function execute(sql:ParameterizedQuery sqlQuery)
    returns sql:ExecutionResult|sql:Error = @java:Method {
        'class: "io.ballerina.lib.aws.redshift.nativeimpl.ExecuteProcessor",
        name: "nativeExecute"
    } external;

    # Executes the SQL query with multiple sets of parameters in a batch. Only the metadata of the execution 
    # is returned (not results from the query). If one of the commands in the batch fails, this will return 
    # an `sql:BatchExecuteError`. However, the driver may or may not continue to process the remaining 
    # commands in the batch after a failure.
    #
    # + sqlQueries - The SQL query with multiple sets of parameters
    # + return - Metadata of the query execution as an `sql:ExecutionResult[]` or an `sql:Error`
    remote isolated function batchExecute(sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        if sqlQueries.length() == 0 {
            return error sql:ApplicationError(" Parameter 'sqlQueries' cannot be empty array");
        }
        return nativeBatchExecute(self, sqlQueries);
    }

    # Executes a SQL query, which calls a stored procedure. This may or may not return results.
    #
    # + sqlQuery - The SQL query such as `` `CALL sp_GetAlbums();` ``
    # + rowTypes - `typedesc` array of the records to which the results need to be returned
    # + return - Summary of the execution and results are returned in an `sql:ProcedureCallResult`, or an `sql:Error`
    remote isolated function call(sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = [])
    returns sql:ProcedureCallResult|sql:Error = @java:Method {
        'class: "io.ballerina.lib.aws.redshift.nativeimpl.CallProcessor",
        name: "nativeCall"
    } external;

    # Closes the client and shuts down the connection pool.
    #
    # + return - Possible error when closing the client
    public isolated function close() returns sql:Error? = @java:Method {
        'class: "io.ballerina.lib.aws.redshift.nativeimpl.ClientProcessor",
        name: "close"
    } external;
}

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

# Possible values for the SSL mode.
public enum SslMode {
    # SSL is disabled and the connection is not encrypted
    DISABLE,
    # SSL is enabled and the server certificate must be verified
    VERIFY_CA,
    # SSL is enabled. The server certificate must be verified and the server hostname must match the hostname attribute on the certificate
    VERIFY_FULL
}

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

isolated function createClient(Client jdbcClient, ClientConfiguration clientConf,
        sql:ConnectionPool globalConnPool) returns sql:Error? = @java:Method {
    'class: "io.ballerina.lib.aws.redshift.nativeimpl.ClientProcessor"
} external;

isolated function nativeBatchExecute(Client sqlClient, string[]|sql:ParameterizedQuery[] sqlQueries)
returns sql:ExecutionResult[]|sql:Error = @java:Method {
    'class: "io.ballerina.lib.aws.redshift.nativeimpl.ExecuteProcessor"
} external;
