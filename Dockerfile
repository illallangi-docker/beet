FROM docker.io/fedora:31

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

RUN dnf -y install \
      findutils \
      git \
      python3 \
      python3-beautifulsoup4 \
      python3-flask \
      python3-pylast \
      python3-requests \
      sqlite \
      which; \
    dnf -y update; \
    pip install -e git+https://github.com/beetbox/beets.git#egg=beets; \
    dnf -y remove git; \
    dnf -y clean all

COPY contrib/confd-0.16.0-linux-amd64 /usr/local/bin/confd
COPY contrib/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
COPY entrypoint.sh /entrypoint.sh
COPY confd/ /etc/confd/

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/confd \
        /usr/local/bin/dumb-init

EXPOSE 8337

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]