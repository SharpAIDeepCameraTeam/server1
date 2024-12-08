#!/bin/bash

# Start Nginx
nginx

# Ensure EULA is accepted
cd /app/server
echo "eula=true" > eula.txt

# Create logs directory
mkdir -p logs

# Start Minecraft server in the background with reduced memory and logging
java -Xmx512M -Xms256M -jar server.jar nogui > logs/minecraft.log 2>&1 &

# Tail the log to see what's happening
tail -f logs/minecraft.log &

# Wait a bit for Minecraft server to start
sleep 20

# Start BungeeCord with minimal memory and logging
cd /app/bungee
java -Xmx256M -jar bungee.jar > logs/bungee.log 2>&1
