/*
 * Copyright (c) 2023 WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.lib.aws.redshift;

import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;

/**
 * This class includes utility functions.
 */
public class Utils {

    public static void addSSLOptions(BMap secureSocket, BMap<BString, Object> options) {
        if (secureSocket == null) {
            options.put(Constants.SSL.SSL_MODE, false);
        } else {
            options.put(Constants.SSL.SSL_MODE, true);
            BString sslrootcert = secureSocket.getStringValue(Constants.SSL.ROOT_CERT);
            options.put(Constants.SSL.SSL_FACTORY_ARG, Constants.SSL.SSL_FACTORY_VALUE.getValue());
            if (sslrootcert != null) {
                options.put(Constants.SSL.SSL_ROOT_CERT_ARG, sslrootcert);
            }
        }
    }
}
