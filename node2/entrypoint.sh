#!/bin/bash

export PATRONI_CONFIG_FILE=/etc/patroni.yml
# Patroni 실행
exec su - postgres -c "patroni /etc/patroni.yml"
