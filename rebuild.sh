#!/bin/bash
# Interim Ant-less build script

APP="reaper"
VER="1.0"
DIR="./out"
# Source and Libraries
LIB="./lib/jain-sip-sdp-1.2.142.jar:./lib/log4j-1.2.15.jar"
SRC="src/com/tt/reaper/*.java src/com/tt/reaper/*/*.java"

# Script
echo "Compiling $APP-$VER ... "
if [ -d "$DIR" ]; then
        read -r -p "Existing output directory! Overwrite? [y/N] " response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
        then
           rm -rf ./out/*
        else
           echo "Exiting.."
           exit 1;
        fi
else
   mkdir out  
fi

if [ -d "reaper" ]; then
        read -r -p "Existing reaper directory! Overwrite? [y/N] " response
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
        then
           rm -rf ./reaper/*
        else
           echo "Exiting.."
           exit 1;
        fi
else
   mkdir reaper
fi

# Compile & Pack
javac -d $DIR -cp $LIB $SRC
cd $DIR
echo "Packing $APP-$VER.jar ... "
jar cvf $APP-$VER.jar * 
mv $APP-$VER.jar ..
# Cleanup
cd ..
rm -rf $DIR
echo; echo "JAR Done!"
# ls -alF $APP-$VER.jar
echo

# TCPDUMP Element
if [ -d "./tcmpdump" ]; then
  echo "Compiling & Patching tcpdump ..."
  cd tcmpdump
  tar zxf tcpdump-4.1.1.tar.gz
  cd tcpdump-4.1.1
  patch -p1 -i ../patch.txt
  cp ../reaper.* ./
  ./configure > /dev/null
  make> /dev/null
  if [ ! -f "./tcpdump" ]; then 
        exit 2; 
  fi
  # Stage files & Cleanup
  cp ./tcpdump ../../bpf
  cd ..
  rm -rf tcpdump-4.1.1
  cd ..
  echo "BPF Done!"
  # ls -alF ./bpf
fi

echo "Assembling DEB package ..."
# BUNCH UP DIST FILES
mkdir reaper/etc
mkdir reaper/etc/init.d
cp reaper.sh reaper/etc/init.d/reaper
mkdir reaper/opt
mkdir reaper/opt/reaper
mkdir reaper/opt/reaper/bin
cp bpf reaper/opt/reaper/bin/
cp filter.sh reaper/opt/reaper/bin/
mkdir reaper/opt/reaper/config
cp config/* reaper/opt/reaper/config/
mkdir reaper/opt/reaper/lib
cp lib/* reaper/opt/reaper/lib
mkdir reaper/DEBIAN
cp -r DEBIAN/* reaper/DEBIAN/
mkdir reaper/opt/reaper/log
cp $APP-$VER.jar reaper/opt/reaper/lib/reaper.jar


# BUILD DEB
chown -R root:root reaper
chmod 775 reaper/DEBIAN
chmod 775 reaper/DEBIAN/*
chmod 755 reaper/etc
chmod 755 reaper/etc/init.d
chmod 755 reaper/etc/init.d/reaper
chmod 755 reaper/opt
chmod 770 reaper/opt/reaper
chmod 770 reaper/opt/reaper/*
chmod 550 reaper/opt/reaper/bin/bpf
chmod 550 reaper/opt/reaper/bin/filter.sh
chmod 770 reaper/opt/reaper/config/*
chmod 550 reaper/opt/reaper/lib/*
chmod 775 reaper/opt/reaper/log
dpkg-deb -b reaper

# Cleanup & Exit
rm -rf ./reaper
echo
exit 0;
