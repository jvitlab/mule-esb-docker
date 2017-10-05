# Docker image  for latest Mulesoft ESB Community Edition.
# Runs sample hello-world esb app.
# Runs on Alpine linux and Oracle Java 8 (JDK).

FROM frolvlad/alpine-oraclejdk8

MAINTAINER JVITConsulting.com https://github.com/jvitlab

# Mule ESB CE version
ENV MULE_ESB_VERSION=3.8.1
ENV MULE_ESB_DOWNLOAD_URL=https://repository-master.mulesoft.org/nexus/content/repositories/releases/org/mule/distributions/mule-standalone/${MULE_ESB_VERSION}/mule-standalone-${MULE_ESB_VERSION}.tar.gz
# Mule home directory in Docker image.
ENV MULE_HOME=/opt/mule-standalone \
    APP_NAME=hello-example.zip
ENV APP_DOWNLOAD_URL=http://mule-studio-examples.s3.amazonaws.com/ce/${APP_NAME}
# HTTP PORT on which application runs
ENV APP_PORT=8888


# Setup mule install location.
RUN mkdir -p /opt && \
    cd /opt && \

# Needed for SSL support when downloading Mule ESB from HTTPS URL.
    apk update && \
    apk --no-cache add ca-certificates && \
     update-ca-certificates && \
    apk --no-cache add openssl && \
 # Install Mule ESB.
    wget ${MULE_ESB_DOWNLOAD_URL} && \
    tar xvzf mule-standalone-*.tar.gz && \
    rm mule-standalone-*.tar.gz && \
    mv mule-standalone-* mule-standalone && \
    rm -rf ${MULE_HOME}/src && \

# Download APP
    wget ${APP_DOWNLOAD_URL} && \

# Deploy APP
    cp ${APP_NAME} $MULE_HOME/apps && \
    rm  ${APP_NAME}

WORKDIR ${MULE_HOME}

# Start Mule ESB.
CMD [ "/opt/mule/bin/mule" ]

# Define mount points.
VOLUME ["${MULE_HOME}/logs", "${MULE_HOME}/conf", "${MULE_HOME}/apps", "${MULE_HOME}/domains"]

# Default http port
EXPOSE 8081
# JMX port.
EXPOSE 1099
#EXPOSE APP PORT
EXPOSE ${APP_PORT}
