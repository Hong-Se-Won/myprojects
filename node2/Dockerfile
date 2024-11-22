FROM rockylinux:8.9

ENV LANG=C.UTF-8
ENV TZ=Asia/Seoul
ENV TERM=xterm-256color

# Enable PowerTools repository and install necessary packages
RUN dnf install -y epel-release && \
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    dnf module disable -y postgresql && \
    dnf config-manager --set-enabled powertools && \
    dnf install -y postgresql16 postgresql16-server postgresql16-contrib && \
    dnf install -y procps htop sysstat net-tools iputils which && \
    dnf install -y python3 python3-pip && \
    dnf install -y perl-IPC-Run && \
    dnf install -y python3 && \
    python3 -m pip install --upgrade pip && \
    pip3 install patroni[etcd] psycopg2-binary && \
    dnf clean all

# Python 패키지 업그레이드
RUN python3 -m pip install --no-cache-dir --upgrade pip==19.2 setuptools==59.6.0

# Patroni 구성 파일 복사
COPY patroni.yml /etc/patroni.yml
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN mkdir -p /var/lib/pgsql/16/data
RUN mkdir -p /var/lib/pgsql/16/certs
RUN chown -R postgres:postgres /var/lib/pgsql
RUN chown -R postgres:postgres /var/lib/pgsql/16/data
RUN chmod 0700 /var/lib/pgsql/16/data

COPY certs/. /var/lib/pgsql/16/certs/
RUN chown -R postgres:postgres /var/lib/pgsql/16/certs/*
RUN chmod 644 /var/lib/pgsql/16/certs/rootCA.crt 
RUN chmod 644 /var/lib/pgsql/16/certs/client.crt

RUN echo "alias ll='ls -alrth'" >> ~/.bashrc

#USER postgres
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]