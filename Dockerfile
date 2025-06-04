FROM public.ecr.aws/codebuild/standard:7.0
# Update and install packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    jq \
    sudo \
    gnupg2 \
    software-properties-common \
    openssh-client

# Install AWS CLI (ensure latest)
RUN pip install --upgrade awscli

# Install kubectl (latest stable)
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Retry install for openssl
RUN for i in 1 2 3; do apt-get install -y --reinstall openssl && break || sleep 3; done

# Clean cache
RUN apt-get clean


