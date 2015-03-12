#!/bin/sh

if [ -z "$BOOTSTRAP_SERVERS" ]; then
	BOOTSTRAP_SERVERS=localhost:9092
fi

if [ -z "$ZOOKEEPER_CONNECT" ]; then
	ZOOKEEPER_CONNECT=localhost:2181
fi

cat >${KAFKA_HTTP_INSTALL_DIR}/kafka-http.yml <<EOF
producer:
  "bootstrap.servers": "${BOOTSTRAP_SERVERS}"
  "key.serializer": "org.apache.kafka.common.serialization.ByteArraySerializer"
  "value.serializer": "org.apache.kafka.common.serialization.ByteArraySerializer"

consumer:
  "zookeeper.connect": "${ZOOKEEPER_CONNECT}"
  "group.id": "group"
  "auto.offset.reset": "smallest"
  "consumer.timeout.ms": "500"
EOF

exec "$@"

