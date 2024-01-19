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
    sql:ParameterizedQuery sqlQuery = `SELECT * FROM your_table_name limit 10`;
    stream<record {}, error?> resultStream = dbClient->query(sqlQuery);
    check from record {} result in resultStream
        do {
            io:println("Full details of users: ", result);
        };
}
