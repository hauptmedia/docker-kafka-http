#!/bin/sh

if [ -z "$ZOOKEEPER_NAME" ]; then
        echo "Missing linked zookeeper container"
        exit 1
fi

if [ -z "$KAFKA_NAME" ]; then
        echo "Missing linked kafka container"
        exit 1
fi

cat >${KAFKA_HTTP_INSTALL_DIR}/kafka-http.yml <<EOF
producer:
  "bootstrap.servers": "${KAFKA_PORT_9092_TCP_ADDR}:${KAFKA_PORT_9092_TCP_PORT}"
  "key.serializer": "org.apache.kafka.common.serialization.ByteArraySerializer"
  "value.serializer": "org.apache.kafka.common.serialization.ByteArraySerializer"

consumer:
  "zookeeper.connect": "${ZOOKEEPER_PORT_2181_TCP_ADDR}:${ZOOKEEPER_PORT_2181_TCP_PORT}"
  "group.id": "group"
  "auto.offset.reset": "smallest"
  "consumer.timeout.ms": "500"
EOF

exec "$@"

