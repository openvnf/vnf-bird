FROM ubuntu:20.04

# Add repository (has to be debugged)

RUN apt update && apt upgrade -y
RUN apt install -qy iputils-ping iputils-tracepath iputils-arping traceroute iproute2 less bird procps
RUN mkdir -p /run/bird
RUN mkdir -p /etc/bird

ENV HOME /root
WORKDIR /root

ADD entry-bird.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/entry-bird.sh
EXPOSE 179

ENTRYPOINT [ "/usr/local/bin/entry-bird.sh" ]
