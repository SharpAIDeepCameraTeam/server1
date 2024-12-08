#!/bin/bash

# Start Nginx
nginx

# Ensure EULA is accepted
cd /app/server
echo "eula=true" > eula.txt

# Start Minecraft server in the background
java -Xmx1024M -Xms1024M -jar server.jar nogui &

# Wait a bit for Minecraft server to start
sleep 10

# Start BungeeCord
cd /app/bungee
java -Xmx512M -jar bungee.jar
