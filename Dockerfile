FROM fedora:34

# Add repository (has to be debugged)

COPY RPM-GPG-KEY-network.cz /etc/pki/rpm-gpg/RPM-GPG-KEY-network.cz
COPY bird.repo /etc/yum.repos.d/bird.repo
RUN dnf install -y iputils traceroute iproute less bird bird6 procps-ng && dnf clean all
RUN mkdir -p /run/bird
RUN mkdir -p /etc/bird

ENV HOME /root
WORKDIR /root

ADD entry-bird.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/entry-bird.sh
EXPOSE 179

ENTRYPOINT [ "/usr/local/bin/entry-bird.sh" ]
