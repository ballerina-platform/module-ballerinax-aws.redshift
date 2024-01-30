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

import ballerina/http;
import ballerina/sql;
import ballerinax/aws.redshift; // Get the AWS Redshift connector
import ballerinax/aws.redshift.driver as _; // Get the AWS Redshift driver

// Connection Configurations
configurable string jdbcUrl = ?;
configurable string user = ?;
configurable string password = ?;

// Initialize the Redshift client
redshift:Client dbClient = check new (jdbcUrl, user, password);

type Album record {|
    string id;
    string title;
    string artist;
    float price;
|};

service / on new http:Listener(8080) {
    private final redshift:Client db;

    function init() returns error? {
        self.db = check new (jdbcUrl, user, password);
    }

    resource function get albums() returns Album[]|error {
        stream<Album, sql:Error?> albumStream = self.db->query(`SELECT * FROM MUSIC_STORE.albums`);
        return from Album album in albumStream select album;
    }

    resource function get albums/[string id]() returns Album|http:NotFound|error {
        Album|sql:Error result = self.db->queryRow(`SELECT * FROM MUSIC_STORE.albums WHERE id = ${id}`);
        if result is sql:NoRowsError {
            return http:NOT_FOUND;
        } else {
            return result;
        }
    }

    resource function post album(@http:Payload Album album) returns Album|error {
        _ = check self.db->execute(`
            INSERT INTO MUSIC_STORE.albums (id, title, artist, price)
            VALUES (${album.id}, ${album.title}, ${album.artist}, ${album.price});`);
        return album;
    }
}
