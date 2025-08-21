FROM debian:bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=20.17.0
ENV JAVA_HOME=/usr/lib/jvm/temurin-11-jdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    lsb-release \
    rsync \
    openssh-client \
    openssh-server \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js using NodeSource repository
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | apt-key add - && \
    echo "deb [arch=amd64] https://packages.adoptium.net/artifactory/deb bookworm main" \
    | tee /etc/apt/sources.list.d/adoptium.list

# Install JDK 8, 11, and 17
RUN apt-get update && apt-get install -y \
    temurin-8-jdk \
    temurin-11-jdk \
    temurin-17-jdk \
    && rm -rf /var/lib/apt/lists/*


# Register JDKs in update-alternatives
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-8-jdk-amd64/bin/java 1080 && \
    update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/temurin-8-jdk-amd64/bin/javac 1080 && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-11-jdk-amd64/bin/java 1110 && \
    update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/temurin-11-jdk-amd64/bin/javac 1110 && \
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/temurin-17-jdk-amd64/bin/java 1170 && \
    update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/temurin-17-jdk-amd64/bin/javac 1170

# Set JDK 8 as default
RUN update-alternatives --set java /usr/lib/jvm/temurin-8-jdk-amd64/bin/java && \
    update-alternatives --set javac /usr/lib/jvm/temurin-8-jdk-amd64/bin/javac

# Install common development tools
RUN npm install -g \
    npm@latest \
    yarn \
    pnpm \
    typescript \
    ts-node \
    nodemon \
    eslint \
    prettier

# Install Maven for Java development
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget -O /tmp/go.tar.gz https://golang.org/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/$DEV_USERNAME/go"
ENV GOBIN="/home/$DEV_USERNAME/go/bin"

# Install additional development tools
RUN apt-get update && apt-get install -y \
    cmake \
    jq \
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    tmux \
    screen \
    ncdu \
    ripgrep \
    fd-find \
    bat \
    && rm -rf /var/lib/apt/lists/*

# Install network tools
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    nmap \
    tcpdump \
    iftop \
    whois \
    traceroute \
    mtr \
    iperf3 \
    socat \
    telnet \
    ftp \
    net-tools \
    iproute2 \
    dnsutils \
    iputils-ping \
    tshark \
    && rm -rf /var/lib/apt/lists/*

# Install git tools and utilities
RUN apt-get update && apt-get install -y \
    git-flow \
    git-lfs \
    tig \
    gh \
    && rm -rf /var/lib/apt/lists/*

# Install encoding/hashing tools
RUN apt-get update && apt-get install -y \
    xxd \
    openssl \
    gnupg \
    sharutils \
    && rm -rf /var/lib/apt/lists/*

# Install comby dependencies and binary
RUN apt-get update && apt-get install -y libev4 libgmp10 libpcre3 && rm -rf /var/lib/apt/lists/* && \
    curl -L https://github.com/comby-tools/comby/releases/download/1.8.1/comby-1.8.1-x86_64-linux.tar.gz -o /tmp/comby.tar.gz && \
    tar -xzf /tmp/comby.tar.gz -C /tmp && \
    mv /tmp/comby-1.8.1-x86_64-linux /usr/local/bin/comby && \
    chmod +x /usr/local/bin/comby && \
    rm -rf /tmp/comby*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'source $HOME/.cargo/env' >> ~/.bashrc
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Python tools and package managers
RUN pip3 install --break-system-packages --upgrade pip setuptools wheel && \
    pip3 install --break-system-packages \
    pipenv \
    poetry \
    virtualenv \
    black \
    flake8 \
    mypy \
    pytest \
    jupyter \
    ipython

# Configure SSH server
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create development user
ARG DEV_USERNAME=dev
ARG DEV_PASSWORD
ARG ROOT_PASSWORD

# Fail build if no password is provided
RUN if [ -z "$DEV_PASSWORD" ]; then \
        echo "ERROR: DEV_PASSWORD must be provided as build argument"; \
        exit 1; \
    fi

# Set root password if provided
RUN if [ -n "$ROOT_PASSWORD" ]; then \
        echo "root:$ROOT_PASSWORD" | chpasswd; \
    fi

# Create development user with provided credentials
RUN useradd -m -s /bin/bash "$DEV_USERNAME" && \
    usermod -aG sudo "$DEV_USERNAME" && \
    echo "$DEV_USERNAME:$DEV_PASSWORD" | chpasswd && \
    echo "$DEV_USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p "/home/$DEV_USERNAME/.ssh" && \
    chmod 700 "/home/$DEV_USERNAME/.ssh" && \
    chown "$DEV_USERNAME:$DEV_USERNAME" "/home/$DEV_USERNAME/.ssh"

# Set working directory
WORKDIR /workspace

# Change ownership of workspace to development user
RUN chown -R "$DEV_USERNAME:$DEV_USERNAME" /workspace

# Expose common development ports and SSH
EXPOSE 3000 8080 8081 9000 22

# Start SSH service 
CMD ["/usr/sbin/sshd", "-D"]