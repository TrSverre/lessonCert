FROM maven:latest as bild
RUN apt update
RUN apt install git -y
WORKDIR /var/www/html
WORKDIR /home/user/
RUN git clone https://github.com/jetty-project/embedded-jetty-live-war
WORKDIR /home/user/embedded-jetty-live-war
RUN mvn package

FROM tomcat:9.0.8-jre8-alpine
COPY --from=bild /home/user/embedded-jetty-live-war/livewar-assembly/target/livewar-example.war /usr/local/tomcat/webapps