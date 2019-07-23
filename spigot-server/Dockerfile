FROM openjdk:8-jre

WORKDIR /minecraft-work
ENV SPIGOT_WORK /minecraft-work
ENV SPIGOT_BUILD /build
ENV SPIGOT /minecraft

RUN apt-get update
RUN apt-get install git -y

COPY run.sh .

RUN chmod +x ./run.sh

CMD trap 'exit' INT; ./run.sh


# ADD ./init.sh /usr/src/minecraft/init.sh
# ADD ./run.sh /usr/src/minecraft/run.sh
# WORKDIR /usr/src/minecraft
# ENV SPIGOT_BUILD /usr/src/build
# ENV SPIGOT /usr/src/minecraft



# RUN ls -l /usr/src/minecraft
# RUN chmod +x /usr/src/minecraft/init.sh
# RUN chmod +x /usr/src/minecraft/run.sh
# RUN ls -l /usr/src/minecraft
# RUN ./build.sh


# RUN ls -l /usr/src/minecraft

# CMD java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar ./spigot.jar
