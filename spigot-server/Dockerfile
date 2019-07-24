FROM openjdk:8-jre

WORKDIR /minecraft-work
ENV SPIGOT_WORK /minecraft-work
ENV SPIGOT_BUILD /build
ENV SPIGOT /minecraft

RUN apt-get update
RUN apt-get install git -y

COPY . .

RUN chmod +x ./run.sh

ENV RCON=true \
    RCON_PASSWORD=9hBM9Hqj4IJu \
    RCON_PORT=25575 \
    GAMEMODE=survival \
    MOTD="Minecraft Server powered by Spigot and Docker" \
    LEVEL=world \
    SEED="" \
    PVP=true \
    VDIST=10 \
    OPPERM=4 \
    NETHER=true \
    FLY=false \
    MAXBHEIGHT=256 \
    NPCS=true \
    WLIST=false \
    ANIMALS=true \
    HC=false \
    ONLINE=true \
    RPACK='' \
    DIFFICULTY=easy \
    CMDBLOCK=false \
    MAXPLAYERS=10 \
    MONSTERS=true \
    STRUCTURES=true \
    SPAWNPROTECTION=16 \
    MAX_TICK_TIME=60000 \
    MAX_WORLD_SIZE=29999984 \
    RPACK_SHA1='' \
    NETWORK_COMPRESSION_THRESHOLD=256 \
    SET_SERVER_PROPERTIES=true \
    FORCE_REBUILD=false \
    EULA=false

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
