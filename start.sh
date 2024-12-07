#!/bin/bash

# Start the Minecraft server in the background
cd server
java -Xmx256M -jar server.jar &

# Wait a bit for the server to start
sleep 10

# Start BungeeCord with reduced memory
cd ../bungee
java -Xmx200M -jar bungee.jar
