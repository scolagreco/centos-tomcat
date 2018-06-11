FROM scolagreco/centos-java:latest

COPY script/* /root/

# USERS
RUN useradd -ms /bin/bash tomcat \
    && echo "tomcat:tomcat" | chpasswd \
# TOMCAT
    && wget http://it.apache.contactlab.it/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.zip \
    && unzip apache-tomcat-8.5.31.zip \
    && rm -Rf apache-tomcat-8.5.31.zip \
    && mv apache-tomcat-8.5.31 /usr/local/tomcat \
    && mkdir /usr/local/tomcat/conf/Catalina \
    && mkdir /usr/local/tomcat/conf/Catalina/localhost \
    && mv /root/logging.properties /usr/local/tomcat/conf/ \
    && chmod -R 755 /usr/local/tomcat \
    && chown -R tomcat:tomcat /usr/local/tomcat \
    && mv /root/tomcat /etc/init.d/tomcat \
    && chmod +x /etc/init.d/tomcat \
    && chkconfig --add tomcat \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /root/* 

# Metadata params
ARG BUILD_DATE
ARG VERSION="v8.5.31"
ARG VCS_URL="https://github.com/scolagreco/centos-tomcat.git"
ARG VCS_REF

# Metadata
LABEL maintainer="Stefano Colagreco <stefano@colagreco.it>" \
        org.label-schema.name="CentOS + Tomcat 8" \
        org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.version=$VERSION \
        org.label-schema.vcs-url=$VCS_URL \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.description="Docker Image CentOS + Tomcat 8"

EXPOSE 8080 8009

ENTRYPOINT /etc/init.d/tomcat restart && bash

