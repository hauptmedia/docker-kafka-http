FROM            hauptmedia/java:oracle-java7

ENV             DEBIAN_FRONTEND noninteractive

ENV		KAFKA_HTTP_VERSION 0.1
ENV		KAFKA_HTTP_DOWNLOAD_URL	https://dl.dropboxusercontent.com/u/47203203/kafka-http/kafka-http-assembly-${KAFKA_HTTP_VERSION}.jar?1427301382
ENV		KAFKA_HTTP_HOME /opt/kafka-http

ENV             RUN_USER            daemon
ENV             RUN_GROUP           daemon

# install needed debian packages & clean up
RUN             apt-get update && \
                apt-get install -y --no-install-recommends curl tar ca-certificates && \
                apt-get clean autoclean && \
                apt-get autoremove --yes && \
                rm -rf /var/lib/{apt,dpkg,cache,log}/

# install kafka-http
RUN		mkdir ${KAFKA_HTTP_HOME} && \
		curl -L --silent ${KAFKA_HTTP_DOWNLOAD_URL} -o ${KAFKA_HTTP_HOME}/kafka-http.jar

COPY		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

EXPOSE		8080

WORKDIR         ${KAFKA_HTTP_HOME}

ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]
CMD		["/usr/bin/java", "-jar", "kafka-http.jar"]
