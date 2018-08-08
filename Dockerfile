FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -qy --no-install-recommends bird iputils-ping traceroute iproute2 less vim netcat curl
RUN mkdir /run/bird

ENV HOME /root
WORKDIR /root

ADD entry-bird.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/entry-bird.sh

ENTRYPOINT [ "/usr/local/bin/entry-bird.sh" ]
