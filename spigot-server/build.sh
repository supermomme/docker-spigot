#!/bin/bash
if [ ! -f $SPIGOT/spigot.jar ]; then
  echo "spigot.jar does not exists!"
  mkdir -p $SPIGOT_BUILD
  cd $SPIGOT_BUILD
  wget -O BuildTools.jar  https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
  echo "BuildTools.jar downloaded"
  echo "Start Build"
  # java -jar BuildTools.jar --help
  java -jar BuildTools.jar --rev 1.14.4 -o $SPIGOT/spigot.jar
  echo "Building finished"
fi
ls $SPIGOT