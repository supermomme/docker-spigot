FROM openjdk:8-jre
COPY . /usr/src/minecraft
WORKDIR /usr/src/minecraft

EXPOSE 25565
# RUN javac Main.java
CMD java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar spigot.jar
