FROM openjdk:8-jre

COPY ./build.sh /usr/src/minecraft/build.sh
COPY ./spigot.jar /usr/src/minecraft/spigot.jar
WORKDIR /usr/src/minecraft
ENV SPIGOT_BUILD /usr/src/build
ENV SPIGOT /usr/src/minecraft

# RUN apt-get update
# RUN apt-get install git -y

RUN chmod +x ./build.sh
RUN ./build.sh

EXPOSE 25565
CMD java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar ./spigot.jar
