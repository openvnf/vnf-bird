FROM fedora:29

# Add repository (has to be debugged)

COPY RPM-GPG-KEY-network.cz /etc/pki/rpm-gpg/RPM-GPG-KEY-network.cz
COPY bird.repo /etc/yum.repos.d/bird.repo
RUN dnf install -y iputils traceroute iproute less bird && dnf clean all
RUN mkdir /run/bird

ENV HOME /root
WORKDIR /root

ADD entry-bird.sh /usr/local/bin
RUN chmod 0755 /usr/local/bin/entry-bird.sh
EXPOSE 179

ENTRYPOINT [ "/usr/local/bin/entry-bird.sh" ]
