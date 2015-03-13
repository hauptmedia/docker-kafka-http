# docker-kafka-http

This docker contains runs the dropwizard-kafka-http endpoint from stealthly (see https://github.com/stealthly/dropwizard-kafka-http)

### Get message for a topic

```bash
curl http://localhost:8080/message?topic=http
```

### Commit message to given topic

```bash
curl -d "topic=http&message=hello&key=0" http://localhost:8080/message
```

