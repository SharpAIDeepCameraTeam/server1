FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy server files
COPY server ./server/
COPY bungee ./bungee/

# Create EULA file
RUN echo "eula=true" > server/eula.txt

# Create a script to run both processes
COPY start.sh .
RUN chmod +x start.sh

# Expose necessary ports
EXPOSE 8081
EXPOSE 25565

CMD ["./start.sh"]
