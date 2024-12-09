#!/bin/bash

# Handle cleanup on script exit
cleanup() {
    echo "Shutting down servers..."
    if [ ! -z "$MC_PID" ]; then
        kill $MC_PID 2>/dev/null || true
    fi
    if [ ! -z "$BUNGEE_PID" ]; then
        kill $BUNGEE_PID 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGTERM SIGINT

# Create necessary directories
mkdir -p /app/server /app/bungee /app/logs

# Download server jar if not present
if [ ! -f /app/server/server.jar ]; then
    echo "Downloading server.jar..."
    curl -o /app/server/server.jar https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar
fi

if [ ! -f /app/bungee/bungee.jar ]; then
    echo "Downloading bungee.jar..."
    curl -o /app/bungee/bungee.jar https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
fi

# Ensure EULA is accepted
cd /app/server
echo "eula=true" > eula.txt

# Start BungeeCord first
cd /app/bungee
echo "Starting BungeeCord..."
java -Xmx200M -Xms100M -XX:+UseG1GC -XX:G1HeapRegionSize=4M \
    -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled \
    -XX:+AlwaysPreTouch -jar bungee.jar &

BUNGEE_PID=$!

# Wait for BungeeCord to start
sleep 20

# Verify BungeeCord is running
if ! kill -0 $BUNGEE_PID 2>/dev/null; then
    echo "Error: BungeeCord failed to start"
    exit 1
fi

# Start Minecraft server
cd /app/server
echo "Starting Minecraft server..."
java -Xmx450M -Xms256M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 -jar server.jar nogui &

MC_PID=$!

# Wait for both processes
echo "Waiting for servers..."
wait $BUNGEE_PID $MC_PID
