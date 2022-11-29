#!/bin/bash
# Created by Alexandre Marcelo (@xandecelo), nov-2022
# More information at https://github.com/xandecelo/httpd-saml2-sp

# Check the existence of a configured IDP_METADATA_XML_URL variable

if [ "$IDP_METADATA_XML_URL" == "" ] 
then
    echo "Variable IDP_METADATA_XML_URL not set. Apache will not start."
    exit 1
fi

# Set the hostname at many files

sed -i -e "s|%%HOSTNAME%%|${SERVICE_HOSTNAME}|g" /etc/apache2/sites-available/000-service.conf
sed -i -e "s|%%HOSTNAME%%|${SERVICE_HOSTNAME}|g" /var/www/index.html
sed -i -e "s|%%HOSTNAME%%|${SERVICE_HOSTNAME}|g" /var/www/private/index.html


# Configure the certificates

test -n "$CERT_FILE" && cp "$CERT_FILE" /etc/apache2/certs/cert1.pem
test -n "$CERT_PRIVATE_KEY" && cp "$CERT_PRIVATE_KEY" /etc/apache2/certs/privkey1.pem
if [ -n "$CERT_FULL_CHAIN" ]
then
    cp "$CERT_FULL_CHAIN" /etc/apache2/certs/fullchain1.pem
else
    sed -i -e 's|^[^#]*SSLCertificateChainFile /etc/apache2/certs/fullchain1.pem|#&|' /etc/apache2/sites-available/000-service.conf
fi

# Configure SAML2 

pushd /etc/apache2/saml2
curl -v $IDP_METADATA_XML_URL -o /etc/apache2/saml2/idp_metadata.xml
mellon_create_metadata app1 "https://${SERVICE_HOSTNAME}/"
cp app1.xml /var/www
popd


# Run Apache HTTPD server at foreground

apachectl -D FOREGROUND

