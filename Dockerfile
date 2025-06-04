FROM debian:bullseye-slim

# Set non-interactive for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    jq \
    git \
    sudo \
    openssh-client \
    openssl \
    python3 \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Docker CLI and dockerd
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install kubectl (latest)
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/

# Add non-root user (optional)
RUN useradd -m builduser && echo "builduser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["bash"]
