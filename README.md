# HTTPD-SAML2-SP

A quick SAML2 Service Provider (SP) environment, using default Apache HTTP Server + mod_auth_mellon on a Ubuntu 20.04 LTS for testing and educational purposes.

## How to use it

This HTTPD server container image is configured with mod_auth_mellon with data provided by any Identity Provider (IdP) through an URL.

These environment variables are used to customize behavior:

### Required

- ```IDP_METADATA_XML_URL```: URL where IDP metadata is available to be downloaded.

### Optional

- ```SERVICE_HOSTNAME```: hostname to be used at this HTTPD server. Should not contain protocols (ex: server.org). Defaults to 'example.org'.

- ```CERT_FILE```: location of the certificate file to be used at the HTTP server.

- ```CERT_PRIVATE_KEY```: location of the private key file to be used at the HTTP server.

- ```CERT_FULL_CHAIN```: location of the full chain file to be used at the HTTP server. If not provided, no TLS chain file will be configured at this HTTP server.

When not provided default self-signed certificates from the HTTP server will be used.


### Configuration Examples:

```bash
# This is required and will be downloaded before the HTTPD server starts.
IDP_METADATA_XML_URL=https://my-idp-server/metadata.xml

# This is optional, but recommended
SERVICE_HOSTNAME=my-sp-server.org

# remeber to create the folder and provide the files using secrets.
CERT_FILE=/opt/secrets/cert.pem
CERT_PRIVATE_KEY=/opt/secrets/privkey.pem
CERT_FULL_CHAIN=/opt/secrets/fullchain.pem

```
## Notes
- This environment was not hardened: scripts, certificates and configurations copied to it will be accessible for anybody with access to the container - so, use it wisely. Do not use sensitive information or harden it first.

- This environment should work with Ubuntu 22.04 LTS, but the ```mellon_create_metadata``` script fails to create the XML SP file.

- This enviroment exposes the SP metadata through the website data for easy access and integration with the Identity Provider (IdP). Again, this environment is intended ONLY for tests and educational purposes, so (1) never expose SP metadata of production enviroments since this is a severe security issue and (2) never use sensitive data for tests like production certificates. If you need a test certificate, you can check [Let's encrypt](https://letsencrypt.org) and request one for free.