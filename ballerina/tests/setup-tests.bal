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

import ballerina/log;
import ballerina/test;

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
    _ = check dbClient->execute(`
        CREATE OR REPLACE FUNCTION NumericProcedure(
            row_id_in BIGINT,
            int_type_in INTEGER,
            bigint_type_in BIGINT,
            double_type_in DOUBLE PRECISION
        )
        RETURNS VOID LANGUAGE plpgsql AS $$
        BEGIN
            INSERT INTO NumericTypes (
                row_id, int_type, bigint_type, double_type
            )
            VALUES (
                row_id_in, int_type_in, bigint_type_in, double_type_in
            );
        END;
        $$;
    `);
    _ = check dbClient->execute(`
        CREATE TABLE IF NOT EXISTS users (
        user_id INT,
        username VARCHAR(255),
        email VARCHAR(255),
        age INT
    );
    `);

    _ = check dbClient->execute(`
        INSERT INTO users (user_id, username, email, age) VALUES
        (1, 'JohnDoe', 'john.doe@example.com', 25),
        (2, 'JaneSmith', 'jane.smith@example.com', 30),
        (3, 'BobJohnson', 'bob.johnson@example.com', 22);
    `);

    _ = check dbClient->execute(`
        CREATE OR REPLACE FUNCTION GetUserInfo(OUT curName refcursor)
        LANGUAGE plpgsql
        AS $$
        BEGIN
            OPEN curName FOR
            SELECT user_id, username, email, age
            FROM users;
        END;
        $$;
    `);

    check dbClient.close();
}

@test:AfterSuite
function afterFunction() returns error? {
    log:printInfo("Cleaning up resources");

    Client dbClient = check new (jdbcUrl, user, password);

    // Drop the function first
    _ = check dbClient->execute(`DROP FUNCTION IF EXISTS NumericProcedure(BIGINT, INTEGER, BIGINT, DOUBLE PRECISION)`);

    // Drop tables in reverse order
    _ = check dbClient->execute(`DROP TABLE IF EXISTS users`);
    _ = check dbClient->execute(`DROP TABLE IF EXISTS CharacterTypes`);
    _ = check dbClient->execute(`DROP TABLE IF EXISTS NumericTypes`);
    _ = check dbClient->execute(`DROP TABLE IF EXISTS Student`);
    _ = check dbClient->execute(`DROP TABLE IF EXISTS DataTypesTest`);

    check dbClient.close();
}
