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

import ballerina/test;
import ballerina/log;

@test:BeforeSuite
function beforeFunction() returns error? {
    log:printInfo("Setting up tables");
    Client dbClient = check new (jdbcUrl, user, password);
    _ = check dbClient->execute(`
        CREATE TABLE IF NOT EXISTS NumericTypes (
        row_id SERIAL PRIMARY KEY,
        int_type INTEGER,
        bigint_type BIGINT,
        double_type DOUBLE PRECISION
    )
    `);
    _ = check dbClient->execute(`
        CREATE TABLE IF NOT EXISTS CharacterTypes (
        row_id SERIAL PRIMARY KEY,
        char_type CHAR(15),
        varchar_type VARCHAR(20)
    )
    `);
    check dbClient.close();
}
