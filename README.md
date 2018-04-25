# SAML2 METAGEN TEST ENVIRONMENT

[![](https://images.microbadger.com/badges/version/gridworkz/metagen-testenv-backoffice.svg)](https://microbadger.com/images/gridworkz/metagen-testenv-backoffice "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/gridworkz/metagen-testenv-backoffice.svg)](https://microbadger.com/images/gridworkz/metagen-testenv-backoffice "Get your own image badge on microbadger.com") [![](https://img.shields.io/github/issues/gridworkz/metagen-testenv.svg)](https://github.com/gridworkz/metagen-testenv/issues "Issue tracker")

METAGEN Test Environment is aimed at Service Providers who want to test their integration with METAGEN without having real METAGEN identities available.
It consists of a WSO2-IS Identity Provider to run locally or on the providers' own server, where they can freely configure test identities.

The environment consists of two elements:
* the actual identity server, based on [WSO2-IS](https://github.com/wso2/product-is);
* a web backoffice based on Node.js which offers a simplified interface for configuring IS service providers, creating identities and exporting metadata.

## Docker

Install `docker` and` docker-compose` on any system (on Mac you can use Docker for Mac), even for windows you can use docker allowing shared folders.

### Alias ​​configuration

```
echo "127.0.0.1 metagen-testenv-identityserver" | sudo tee -a /etc/hosts
```

On Windows this alias can be configured in `% windir% \ System32 \ drivers \ etc \ HOSTS`.

### Use of the container

Starting with `docker-compose` (not in the background):

```bash
$ docker-compose up
```

Starting in the background with `docker-compose` (detached mode):

```bash
$ docker-compose up -d
```

### Using containers on OSX with docker-machine (not Docker for Mac)

The standard docker-machine does not provide automatic mapping of the ports from the local host to the docker machine.
You can use different techniques, one of which is the following:

```
docker-machine ssh default -L 9443:localhost:9443
```

This creates a ssh port-forward from the vm to localhost, so you can access `https: // localhost: 9443`

### Service availability

It can take a few minutes to start up.
The identity server administration interface will be available in https: // localhost: 9443 / (user: admin, password: admin)
but **it is not necessary** to open it as configuration tasks will be available on https: // localhost: 8080 (the back-office).

## Use of the backoffice

### Configuring a Service Provider

The first step is to configure your Service Provider in the test environment so that it is recognized by the Identity Provider (WSO2-IS), just as you would with the accreditation 
procedure in METAGEN. After opening the backoffice and filling in all parts of the form, you can see on the right the preview of the XML / SAML metadata that describes the Service Provider. 
It is advisable to download the XML file before submitting the form as it will also serve in the configuration of your Service Provider. Pressing the "Save" button the Service Provider 
is created in WSO2-IS. Subsequent changes can be made to an existing service provider by sending the module again with the entity ID and the name unchanged.

#### Important note for MacOS X

Due to a WSO2-is bug on MacOS X, you need to follow the creation of a Service Provider as follows:

1.  Create the Service Provider from the backoffice interface as normal. This operation will be successful but WSO2 will not import the entered certificate.
2.  Access the WSO2 management interface ( https: // localhost: 9443 ).
3.  Select Keystores > List
4.  Click "Import Cert" next to the listed keystore
5.  Run the command $ security unlock-keychain
6.  Upload the certificate
7.  Select Service Providers > List
8.  Click "Edit" next to the newly created Service Provider
9.  Open the tab "Inbound Authentication Configuration" and then "SAML2 Web SSO Configuration"
10. Click "Edit" next to the only item in the table
11. Select the certificate from the dropdown indicated as "Certificate alias"
12. Click on "Update"

### Creation of identities (users)

For each configured Service Provider you can access the list of users and you can create new ones.
