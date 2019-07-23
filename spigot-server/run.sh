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

# PLUGINS

echo "RUN!"
java -Xms512M -Xmx1024M -XX:MaxPermSize=128M -jar $SPIGOT/spigot.jar