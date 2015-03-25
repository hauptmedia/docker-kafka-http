# docker-kafka-http

This docker contains runs the Kafka HTTP endpoint from Hauptmedia (see https://github.com/hauptmedia/kafka-http)

### Quick start

Run in test mode with the embedded Kafka/ZooKeeper and topic "test"

```bash
docker run -i -t --rm -p 127.0.0.1:8080:8080 hauptmedia/kafka-http
```

### Post messages to given topic

```bash
curl -X POST \
-d data='[{"key":"0","message":"Message 1"},{"key":"1","message":"Message 2"}]' \
http://localhost:8080/topic/test/
```

### Get messages for a topic

```bash
curl "http://localhost:8080/topic/test/?limit=2"
```

### Production configuration

You can run the container with all command line documented at https://github.com/hauptmedia/kafka-http/blob/master/README.md 

```bash
docker run -d \
-p 0.0.0.0:8888:8888 hauptmedia/kafka-http \
java -Dconsumer.topics=topic1,topic2 -Dproducer.topics=topic1 -Dhttp.port=8888 -jar kafka-http.jar
```
