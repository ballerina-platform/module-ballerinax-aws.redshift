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
    groups: ["execute"]
}
function testCreateTable() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult result = check dbClient->execute(`
        CREATE TABLE Student(student_id int, LastName varchar(255))
    `);
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 0, "Affected row count is different.");
    test:assertExactEquals(result.lastInsertId, (), "Last Insert Id is not nil.");
}

@test:Config {
    groups: ["execute"],
    dependsOn: [testCreateTable]
}
function testInsertTable() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult result = check dbClient->execute(`Insert into Student (student_id) values (20)`);
    check dbClient.close();

    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    int|string? insertId = result.lastInsertId;
    if insertId is int {
        test:assertTrue(insertId > 1, "Last Insert Id is nil.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
}

@test:Config {
    groups: ["execute"]
}
function testCreateTableWithDataTypes() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult result = check dbClient->execute(`
        CREATE TABLE DataTypesTest (
            smallint_col SMALLINT,
            int_col INTEGER NOT NULL,
            bigint_col BIGINT,
            decimal_col DECIMAL(10, 2),
            real_col REAL,
            double_col DOUBLE PRECISION,
            boolean_col BOOLEAN,
            char_col CHAR(10),
            varchar_col VARCHAR(255),
            date_col DATE,
            timestamp_col TIMESTAMP,
            timestamptz_col TIMESTAMPTZ,
            time_col TIME,
            timetz_col TIMETZ
        )
    `);
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 0, "Affected row count is different.");
    test:assertExactEquals(result.lastInsertId, (), "Last Insert Id is not nil.");
}

@test:Config {
    groups: ["execute"],
    dependsOn: [testCreateTableWithDataTypes]
}
function testInsertDataWithDifferentTypes() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO DataTypesTest VALUES 
        (1, 123, 1234567890, 123.45, 3.14, 6.28, true, 'TestChar', 'TestVarchar', 
        '2024-02-07', '2024-02-07 12:00:00', '2024-02-07 12:00:00+00:00', 
        '12:00:00', '12:00:00+00:00')
    `);
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    test:assertExactEquals(getInsertedNumericValue(), <decimal>123.45, "Numeric value mismatch.");
}

type DecimalColumn record {|
    decimal decimal_col;
|};

function getInsertedNumericValue() returns decimal|error {
    Client dbClient = check new (jdbcUrl, user, password);
    stream<DecimalColumn, sql:Error?> decimalStream = dbClient->query(`SELECT decimal_col FROM DataTypesTest`);
    check from DecimalColumn column in decimalStream
        do {
            return column.decimal_col;
        };
    return 0.0;
}

@test:Config {
    groups: ["execute"],
    dependsOn: [testCreateTableWithDataTypes]
}
function testInsertStringIntoIntegerColumn() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult|sql:Error result = dbClient->execute(`
        INSERT INTO DataTypesTest (int_col) VALUES ('InvalidString')
    `);
    check dbClient.close();
    if result is sql:ExecutionResult {
        test:assertFail("Expected a type mismatch error, but the query executed successfully.");
    }
}

@test:Config {
    groups: ["execute"],
    dependsOn: [testCreateTableWithDataTypes]
}
function testInsertNullIntoNotNullColumn() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult|sql:Error result = dbClient->execute(`
        INSERT INTO DataTypesTest (int_col) VALUES (NULL)
    `);
    check dbClient.close();
    if result is sql:ExecutionResult {
        test:assertFail("Expected a NOT NULL constraint violation error, but the query executed successfully.");
    }
}

@test:Config {
    groups: ["execute"]
}
function testInvalidSqlQuery() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ExecutionResult|sql:Error result = dbClient->execute(`
        INVALID SQL QUERY
    `);
    check dbClient.close();
    if result is sql:ExecutionResult {
        test:assertFail("Expected an SQL syntax error, but the query executed successfully.");
    }
}

