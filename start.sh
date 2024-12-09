#!/bin/bash

# Create necessary directories
mkdir -p /app/server /app/bungee /app/logs

# Ensure EULA is accepted
cd /app/server
echo "eula=true" > eula.txt

# Start Minecraft server in the background with reduced memory
java -Xmx450M -Xms256M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar server.jar nogui &

# Store Minecraft server PID
MC_PID=$!

# Wait for Minecraft server to start
sleep 30

# Start BungeeCord and wait for it
cd /app/bungee
exec java -Xmx200M -Xms100M -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar bungee.jar

# If BungeeCord exits, kill Minecraft server
kill $MC_PID
