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
  setServerProp "rcon.port" "$RCON_PORT"
  setServerProp "rcon.password" "$RCON_PASSWORD"
  setServerProp "enable-rcon" "$RCON"
fi

# PLUGINS

mkdir -p $SPIGOT/plugins

## DYNMAP

if [ "$PLUGIN_DYNMAP" = true ]; then
  if [ ! -f $SPIGOT/plugins/dynmap.jar ]; then
    echo "Download DYNMAP"
    wget -O $SPIGOT/plugins/dynmap.jar http://mikeprimm.com/dynmap/builds/dynmap/Dynmap-HEAD-spigot.jar
  fi

  if [ ! -f $SPIGOT/plugins/dynmap-mobs.jar ]; then
    echo "Download DYNMAP-MOBS"
    wget -O $SPIGOT/plugins/dynmap-mobs.jar http://mikeprimm.com/dynmap/builds/dynmap-mobs/dynmap-mobs-HEAD.jar
  fi

else
  echo "Removing DYNMAP"
  rm -f $SPIGOT/plugins/dynmap.jar
  rm -f $SPIGOT/plugins/dynmap-mobs.jar
fi

## MUTLIVERSE

if [ "$PLUGIN_MULTIVERSE" = true ]; then
  if [ ! -f $SPIGOT/plugins/multiverse-core.jar ]; then
    echo "Download MULTIVERSE-CORE"
    wget -O $SPIGOT/plugins/multiverse-core.jar https://dev.bukkit.org/projects/multiverse-core/files/latest
  fi

  if [ ! -f $SPIGOT/plugins/multiverse-portals.jar ]; then
    echo "Download MULTIVERSE-PORTALS"
    wget -O $SPIGOT/plugins/multiverse-portals.jar https://dev.bukkit.org/projects/multiverse-portals/files/latest
  fi  
else
  echo "Removing MULTIVERSE"
  rm -f $SPIGOT/plugins/multiverse-core.jar
  rm -f $SPIGOT/plugins/multiverse-portals.jar
fi

echo "RUN!"
java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar $SPIGOT/spigot.jar