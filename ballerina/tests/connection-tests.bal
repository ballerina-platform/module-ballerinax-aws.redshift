// Copyright (c) 2024 WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
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

import ballerina/sql;
import ballerina/test;
import ballerinax/postgresql.driver as _;

@test:Config {
    groups: ["connection"]
}
isolated function testConnectionInit() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    error? closeResult = dbClient.close();
    test:assertExactEquals(closeResult, (), "Initialising connection with url, user and password fields fails.");
}

@test:Config {
    groups: ["connection"]
}
function testWithNamedArgs() returns error? {
    Client dbClient = check new (password = password, user = user, url = jdbcUrl);
    error? closeResult = dbClient.close();
    test:assertExactEquals(closeResult, (), "Initialising connection with named args fails.");
}

@test:Config {
    groups: ["connection"]
}
function testWithConnectionParams1() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {
        properties: {"ConnectionTimeout": "300"}
    };
    Client dbClient = check new (password = password, user = user, url = jdbcUrl, options = options, connectionPool = connectionPool);
    error? closeResult = dbClient.close();
    test:assertExactEquals(closeResult, (), "Initialising connection with connection params fails.");
}
