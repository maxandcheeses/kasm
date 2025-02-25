FROM debian:bookworm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo \
    dnsutils \
    iproute2 \
    net-tools \
    iputils-ping \
    netcat-traditional

# Add yq for to extract keys during install script
# Download and install yq
RUN curl -sSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update APT package index again
RUN apt-get update

# Install Docker
RUN apt-get install -y docker-ce docker-ce-cli containerd.io

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Start the Docker daemon
CMD ["/bin/sh", "-c", "rm -f /var/run/docker.pid && dockerd"]