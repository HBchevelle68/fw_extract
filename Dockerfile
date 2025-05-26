# Use the latest Ubuntu base image
FROM ubuntu:latest


# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    unzip \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*


# Set working directory
WORKDIR /opt

# Clone the DumprX repository
RUN git clone https://github.com/DumprX/DumprX.git

# Change working directory to the repo
WORKDIR /opt/DumprX

# Make setup.sh executable and run it
RUN chmod +x setup.sh && ./setup.sh

COPY ./extract.sh .
RUN chmod +x extract.sh 
    
# Declare /data as a mountable volume
VOLUME ["/data"]

# Set default shell
ENTRYPOINT [ "./extract.sh" ]
