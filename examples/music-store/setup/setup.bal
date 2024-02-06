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
import ballerinax/aws.redshift; // Get the AWS Redshift connector
import ballerinax/aws.redshift.driver as _; // Get the AWS Redshift driver

// Connection Configurations
configurable string jdbcUrl = ?;
configurable string user = ?;
configurable string password = ?;

// Initialize the Redshift client
redshift:Client dbClient = check new (jdbcUrl, user, password);

public function main() returns sql:Error? {

    // Creates a database.
    _ = check dbClient->execute(`CREATE SCHEMA IF NOT EXISTS MUSIC_STORE;`);

    // Creates `albums` table in the `MUSIC_STORE` schema.
    _ = check dbClient->execute(`CREATE TABLE MUSIC_STORE.albums (
                                        id VARCHAR(100) NOT NULL PRIMARY KEY,
                                        title VARCHAR(100),
                                        artist VARCHAR(100),
                                        price REAL
                                    );`);

    // Adds the records to the `albums` table in the `MUSIC_STORE` schema.
    _ = check dbClient->execute(`INSERT INTO MUSIC_STORE.albums
                                    VALUES('A-123', 'Lemonade', 'Beyonce', 18.98);`);
    _ = check dbClient->execute(`INSERT INTO MUSIC_STORE.albums
                                    VALUES('A-321', 'Renaissance', 'Beyonce', 24.98);`);

    check dbClient.close();
}
