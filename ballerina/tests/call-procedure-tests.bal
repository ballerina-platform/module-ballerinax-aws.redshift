import ballerina/io;
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
    groups: ["procedures"]
}
function testNumericProcedureCall() returns error? {
    int rowId = 35;
    sql:IntegerValue intType = new (1);
    int bigintType = 123456;
    float double_type = 123.456;

    sql:ParameterizedCallQuery sqlQuery =
    `
      SELECT NumericProcedure(${rowId}, ${intType}, ${bigintType}, ${double_type});
    `;
    _ = check callProcedure(sqlQuery, [NumericProcedureRecord]);

    sql:ParameterizedQuery query = `SELECT row_id, int_type, bigint_type, double_type
        FROM NumericTypes WHERE row_id = ${rowId}`;

    NumericProcedureRecord expectedDataRow = {
        row_id: rowId,
        int_type: 1,
        bigint_type: 123456,
        double_type: 123.456
    };
    test:assertEquals(check queryProcedureClient(query, NumericProcedureRecord), expectedDataRow, "Numeric Call procedure insert and query did not match.");
}

@test:Config {
    groups: ["procedures"]
}
function testStoredProcedureWithCursor() returns error? {
    Client dbClient = check new (jdbcUrl, user, password);
    record {}[] expected = [
        {"user_id": 1, "email": "john.doe@example.com", "age": 25, "username": "JohnDoe"},
        {"user_id": 2, "email": "jane.smith@example.com", "age": 30, "username": "JaneSmith"},
        {"user_id": 3, "email": "bob.johnson@example.com", "age": 22, "username": "BobJohnson"}
    ];
    transaction {
        sql:CursorOutParameter mycursor = new ();
        _ = check dbClient->call(`{CALL GetUserInfo(${mycursor})}`);
        stream<record {}, sql:Error?> resultSet = mycursor.get();
        check commit;
        record {}[] resultArray = check from record {} user in resultSet
            select user;

        test:assertEquals(resultArray, expected, msg = "The results does not match the expected");
    }
}

function callProcedure(sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = []) returns sql:ProcedureCallResult|error {
    Client dbClient = check new (jdbcUrl, user, password);
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, rowTypes);
    check dbClient.close();
    return result;
}

function queryProcedureClient(sql:ParameterizedQuery sqlQuery, typedesc<record {}>? resultType = ())
returns record {}|error {
    Client dbClient = check new (jdbcUrl, user, password);
    stream<record {}, error?> streamData;
    if resultType is () {
        streamData = dbClient->query(sqlQuery);
    } else {
        streamData = dbClient->query(sqlQuery, resultType);
    }
    record {|record {} value;|}? data = check streamData.next();
    check streamData.close();
    record {}? value = data?.value;
    check dbClient.close();
    if value is () {
        return {};
    } else {
        return value;
    }
}

