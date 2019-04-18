FROM openjdk:8u181-jdk-stretch
RUN mkdir /var/local/ewpsp
WORKDIR /var/local/ewpsp
ADD ewp-api-0.0.1-SNAPSHOT.jar ./ewpsp.jar
CMD ["/usr/bin/java", "-jar", "./ewpsp.jar"]
