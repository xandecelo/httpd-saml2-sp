# Created by Alexandre Marcelo (@xandecelo), nov-2022
# More information at https://github.com/xandecelo/httpd-saml2-sp
# This image is available at https://github.com/xandecelo/httpd-saml2-sp

FROM ubuntu:20.04
ENV HOME_DIR=/opt/httpd-saml2-sp

# Image configuration
RUN apt-get update
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata apt-utils
RUN apt-get -y install apache2 libapache2-mod-auth-mellon curl
RUN a2enmod ssl auth_mellon proxy proxy_http proxy_http2 headers 
RUN a2dismod status 
RUN a2dissite 000-default

# httpd-saml2-sp configuration
RUN mkdir -p ${HOME_DIR} /etc/apache2/saml2 /etc/apache2/certs

COPY conf/    /etc/apache2/
COPY www/     /var/www/
COPY scripts/ ${HOME_DIR} 

RUN chmod +x  ${HOME_DIR}/*

# default environmet variables values
ENV SERVICE_HOSTNAME=example.org
ENV CERT_FILE=/etc/ssl/certs/ssl-cert-snakeoil.pem
ENV CERT_PRIVATE_KEY=/etc/ssl/private/ssl-cert-snakeoil.key
ENV IDP_METADATA_XML_URL=""

# enable the service site
RUN a2ensite 000-service

WORKDIR ${HOME_DIR}

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "${HOME_DIR}/run.sh" ]
