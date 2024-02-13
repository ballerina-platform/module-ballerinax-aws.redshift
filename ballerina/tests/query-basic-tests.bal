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

@test:Config {
    groups: ["query-row"]
}
function TestConnectionClose() returns error? {
    sql:ParameterizedQuery sqlQuery = `SELECT username FROM users WHERE user_id = 2;`;
    Client dbClient = check new (jdbcUrl, user, password);
    string stringVal = check dbClient->queryRow(sqlQuery);
    test:assertEquals(stringVal, "JaneSmith");
    check dbClient.close();
}
