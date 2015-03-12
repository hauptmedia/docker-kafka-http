FROM            hauptmedia/java:oracle-java7

ENV             DEBIAN_FRONTEND noninteractive

ENV		MAVEN_VERSION 3.2.5
ENV		MAVEN_DOWNLOAD_URL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
ENV		MAVEN_INSTALL_DIR /opt/apache-maven

ENV		KAFKA_HTTP_INSTALL_DIR /opt/kafka-http

ENV             RUN_USER            daemon
ENV             RUN_GROUP           daemon

# install needed debian packages & clean up
RUN             apt-get update && \
                apt-get install -y --no-install-recommends curl tar ca-certificates git && \
                apt-get clean autoclean && \
                apt-get autoremove --yes && \
                rm -rf /var/lib/{apt,dpkg,cache,log}/

# install maven
RUN             mkdir -p ${MAVEN_INSTALL_DIR} && \
                curl -L --silent ${MAVEN_DOWNLOAD_URL} | tar -xz --strip=1 -C ${MAVEN_INSTALL_DIR}

ENV		PATH /opt/apache-maven/bin:$PATH

# compile & install kafka-http
RUN		cd /tmp && \
		git clone https://github.com/hauptmedia/dropwizard-kafka-http.git && \
		cd /tmp/dropwizard-kafka-http && \
		mvn clean install && \
		mvn package && \
		mkdir -p ${KAFKA_HTTP_INSTALL_DIR} && \
		cp /tmp/dropwizard-kafka-http/target/dropwizard-kafka-http-0.0.1-SNAPSHOT.jar ${KAFKA_HTTP_INSTALL_DIR} && \
		chown -R ${RUN_USER}:${RUN_GROUP} ${KAFKA_HTTP_INSTALL_DIR} && \
		rm -rf /tmp/*

COPY		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh

EXPOSE		8080

WORKDIR         ${KAFKA_HTTP_INSTALL_DIR}

ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]
CMD		["java", "-jar", "dropwizard-kafka-http-0.0.1-SNAPSHOT.jar", "server", "kafka-http.yml"]

