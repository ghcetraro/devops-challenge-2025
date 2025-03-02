FROM ubuntu:22.04
#
USER root
#
ENV DEBIAN_FRONTEND noninteractive
#
RUN apt-get update

# git
RUN apt-get install -y git curl wget gpg nano

# java
RUN apt-get install -y openjdk-8-jdk && apt-get clean
RUN apt-get install -y openjdk-21-jre

# certs
RUN apt-get install -y ca-certificates-java && apt-get clean && update-ca-certificates -f

# maven
RUN apt-get install -f maven

# postgress
RUN apt-get install -y postgresql-client

# visual code
RUN cd /tmp
RUN wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code_1.97.2-1739406807_amd64.deb
RUN apt install -y xdg-utils libgbm1
RUN apt-get install -y alsa-topology-conf alsa-ucm-conf libasound2 libasound2-data libcurl3-gnutls libldap-2.5-0 libldap-common libnghttp2-14 libnspr4 libnss3 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libssh-4
RUN apt-get install -y libasound2-plugins alsa-utils libsasl2-modules-gssapi-mit
RUN apt-get install -y alsa-topology-conf alsa-ucm-conf libasound2 libasound2-data libcurl3-gnutls libldap-2.5-0 libldap-common libnghttp2-14 libnspr4 libnss3 librtmp1 libsasl2-2 libsasl2-modules libsasl2-modules-db libssh-4

RUN dpkg -i code_1.97.2-1739406807_amd64.deb

