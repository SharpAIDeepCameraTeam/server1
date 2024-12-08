#!/bin/bash

# Start Nginx
nginx

# Start Minecraft server in the background
cd /app/server
java -Xmx512M -jar server.jar nogui &

# Wait a bit for Minecraft server to start
sleep 10

# Start BungeeCord
cd /app/bungee
java -Xmx512M -jar bungee.jar
