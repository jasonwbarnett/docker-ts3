# -----------------------------------------------------------------------------
# docker-ts3
#
# Builds a basic docker image that can run TeamSpeak
# (http://teamspeak.com/).
#
# Authors: Jason Barnett
# Updated: Dec 15th, 2014
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------
FROM        phusion/baseimage:latest
MAINTAINER  Jason Barnett <J@sonBarnett.com>

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Make sure we don't get notifications we can't answer during building.
ENV TS3_VERSION 3.0.11.2

# Download and install everything from the repos.
RUN apt-get --yes update
RUN apt-get --yes upgrade
RUN apt-get --yes install curl

# Download and install TeamSpeak 3 Server
RUN curl "http://dl.4players.de/ts/releases/${TS3_VERSION}/teamspeak3-server_linux-amd64-${TS3_VERSION}.tar.gz" -o teamspeak3-server_linux-amd64-${TS3_VERSION}.tar.gz
RUN mkdir /opt/teamspeak3-server
RUN tar --strip-components=1 -zxf teamspeak3-server_linux-amd64-${TS3_VERSION}.tar.gz -C /opt/teamspeak3-server
RUN cp /opt/teamspeak3-server/redist/libmariadb.so.2 /opt/teamspeak3-server
ADD ts3server.ini /opt/teamspeak3-server/ts3server.ini
ADD ts3db_mariadb.ini /opt/teamspeak3-server/ts3db_mariadb.ini
RUN rm -f teamspeak3-server_linux-amd64-${TS3_VERSION}.tar.gz

ADD ./scripts/ts3-server /opt/ts3-server
RUN chmod +x /opt/ts3-server

EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

CMD [ "/opt/ts3-server" ]
