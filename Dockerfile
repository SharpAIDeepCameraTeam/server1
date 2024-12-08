FROM openjdk:8-jdk-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy server files
COPY . .

# Make scripts executable
RUN chmod +x main.sh start.sh

# Create necessary directories and accept EULA
RUN mkdir -p /app/bungee /app/server && \
    echo "eula=true" > /app/server/eula.txt

# Expose ports
EXPOSE 80 25565 25566 8081

# Set environment variable for Java
ENV JAVA_OPTS="-Xmx1G"

# Start command
CMD ["./start.sh"]
