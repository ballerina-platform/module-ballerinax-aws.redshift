# Ballerina AWS Redshift Connector Test Module

This test module is written to test the functionality of the Ballerina AWS Redshift Connector.

## Docker Image

For testing purposes, this [docker-pgredshift](https://github.com/HearthSim/docker-pgredshift/pkgs/container/docker-pgredshift) Docker image is used. It emulates AWS Redshift but with limited features, and it does not support SSL.

## Emulated AWS Redshift Features

The docker-pgredshift image provides a simulated environment resembling AWS Redshift. However, it is essential to be aware of the limited features and the absence of SSL support in this emulation.

## Connection Details

To establish a connection with the emulated AWS Redshift, the Ballerina AWS Redshift Connector uses the [Ballerina PostgreSQL Driver](https://github.com/ballerina-platform/module-ballerinax-postgresql.driver/) as the docker-pgredshift image is based on PostgreSQL and does not connect with the Redshift driver.

## Usage

Follow these steps to manually run the test module:

1. Pull the docker-pgredshift image from [here](https://github.com/HearthSim/docker-pgredshift/pkgs/container/docker-pgredshift).
2. Set up the docker-pgredshift container to emulate AWS Redshift.
3. Use the Ballerina AWS Redshift Connector in your Ballerina programs to interact with the emulated AWS Redshift instance.

## Reference Links

- [docker-pgredshift Image](https://github.com/HearthSim/docker-pgredshift/pkgs/container/docker-pgredshift)
- [Ballerina PostgreSQL Driver](https://github.com/ballerina-platform/module-ballerinax-postgresql.driver/)
