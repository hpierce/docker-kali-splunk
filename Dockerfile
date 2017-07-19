FROM hpierce/docker-kali-base
MAINTAINER Hugh Pierce

ENV DEBIAN_FRONTEND noninteractive

ENV F splunk-6.6.1-aeae3fe0c5af-Linux-x86_64.tgz
ENV D https://download.splunk.com/products/splunk/releases/6.6.1/linux/$F

# Add user splunk
RUN groupadd -r splunk && useradd -r -m -g splunk splunk

# make the "en_US.UTF-8" locale so splunk will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A \
    /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

# Download official Splunk release, verify checksum and unzip in /opt/splunk
# OPTIMISTIC variable fixes 'splunkd validatedb failed with code 1'
RUN cd /opt && wget -q $D && wget -q ${D}.md5 && md5sum -c ${F}.md5 && \
    tar xzf ${F} && rm ${F}*  && chown -R splunk:splunk splunk && \
    echo -e "\nOPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> splunk/etc/splunk-launch.conf.default 

# Ports Splunk Web, Splunk Daemon, KVStore, Splunk Indexing Port, 
# Network Input, HTTP Event Collector
EXPOSE 8000/tcp 8089/tcp 8191/tcp 9997/tcp 1514 8088/tcp

ENTRYPOINT su - splunk -c "/opt/splunk/bin/splunk --accept-license start" && \
           /bin/bash

