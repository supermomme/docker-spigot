#!/bin/bash
set -e

cd $SPIGOT

if [ "$FORCE_REBUILD" = true ] || [ ! -f $SPIGOT/spigot.jar ]; then
  echo "spigot.jar does not exists or FORCE_REBUILD is true! Start Download and Building ..."
  start_time=`date +%s`
  echo "CLEANUP..."
  mkdir -p $SPIGOT_BUILD
  cd $SPIGOT_BUILD
  rm -rf *
  rm -rf $SPIGOT/*
  wget -O BuildTools.jar  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  echo "BuildTools.jar downloaded"
  echo "Start Build"
  git config --global core.autocrlf true
  java -jar BuildTools.jar --rev $REV
  cp -rf ./spigot-*.jar $SPIGOT/spigot.jar
  echo "Building finished."
  cd $SPIGOT
  end_time=`date +%s`
  echo "Building done in " $(expr `date +%s` - $start_time) "seconds"
fi

# eula

if [ "$EULA" = true ]; then
  cp $SPIGOT_WORK/eula.txt $SPIGOT/eula.txt
fi

# server.properties

function setServerProp {
  local prop=$1
  local var=$2
  if [ -n "$var" ]; then
    echo "Setting $prop to $var"
    sed -i "/$prop\s*=/ c $prop=$var" $SPIGOT/server.properties
  fi
}

if [ "$SET_SERVER_PROPERTIES" = true ]; then
  cp $SPIGOT_WORK/server.properties $SPIGOT/server.properties

  setServerProp "motd" "$MOTD"
  setServerProp "level-name" "$LEVEL"
  setServerProp "level-seed" "$SEED"
  setServerProp "pvp" "$PVP"
  setServerProp "view-distance" "$VDIST"
  setServerProp "op-permission-level" "$OPPERM"
  setServerProp "allow-nether" "$NETHER"
  setServerProp "allow-flight" "$FLY"
  setServerProp "max-build-height" "$MAXBHEIGHT"
  setServerProp "spawn-npcs" "$NPCS"
  setServerProp "white-list" "$WLIST"
  setServerProp "spawn-animals" "$ANIMALS"
  setServerProp "hardcore" "$HC"
  setServerProp "online-mode" "$ONLINE"
  setServerProp "resource-pack" "$RPACK"
  setServerProp "difficulty" "$DIFFICULTY"
  setServerProp "enable-command-block" "$CMDBLOCK"
  setServerProp "max-players" "$MAXPLAYERS"
  setServerProp "spawn-monsters" "$MONSTERS"
  setServerProp "generate-structures" "$STRUCTURES"
  setServerProp "spawn-protection" "$SPAWNPROTECTION"
  setServerProp "max-tick-time" "$MAX_TICK_TIME"
  setServerProp "max-world-size" "$MAX_WORLD_SIZE"
  setServerProp "resource-pack-sha1" "$RPACK_SHA1"
  setServerProp "network-compression-threshold" "$NETWORK_COMPRESSION_THRESHOLD"
  setServerProp "gamemode" "$GAMEMODE"
fi


# spawn-protection=16
# max-tick-time=60000
# query.port=25565
# generator-settings=
# force-gamemode=false
# allow-nether=true
# enforce-whitelist=false
# gamemode=survival
# broadcast-console-to-ops=true
# enable-query=false
# player-idle-timeout=0
# difficulty=easy
# broadcast-rcon-to-ops=true
# spawn-monsters=true
# op-permission-level=4
# pvp=true
# snooper-enabled=true
# level-type=default
# hardcore=false
# enable-command-block=false
# network-compression-threshold=256
# max-players=20
# max-world-size=29999984
# resource-pack-sha1=
# function-permission-level=2
# rcon.port=25575
# server-port=25565
# debug=false
# server-ip=
# spawn-npcs=true
# allow-flight=false
# level-name=world
# view-distance=10
# resource-pack=
# spawn-animals=true
# white-list=false
# rcon.password=
# generate-structures=true
# online-mode=true
# max-build-height=256
# level-seed=
# prevent-proxy-connections=false
# use-native-transport=true
# motd=A Minecraft Server
# enable-rcon=false

# PLUGINS

echo "RUN!"
java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar $SPIGOT/spigot.jar