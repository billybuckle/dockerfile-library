# Use an official lightweight Debian image
FROM debian:bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic utilities
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    zsh \
    openssh-client \
    build-essential \
    libssl-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    zlib1g-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    gnupg \
    ca-certificates \
    unzip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Set zsh as default shell
SHELL ["/bin/zsh", "-c"]
RUN chsh -s /bin/zsh

# Install Python 3.13 from source (alpha/beta version)
RUN mkdir -p /usr/src/python && \
    cd /usr/src/python && \
    curl -O https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz && \
    tar -xf Python-3.12.9.tgz && \
    cd Python-3.12.9 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    ln -s /usr/local/bin/python3.12 /usr/bin/python3.12 && \
    ln -s /usr/local/bin/pip3.12 /usr/bin/pip3.12

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && apt-get install -y google-cloud-sdk

# Install Terraform
ENV TERRAFORM_VERSION=1.6.6
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Create a non-root user (optional but recommended)
RUN useradd -ms /bin/zsh dev && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER dev
WORKDIR /home/dev

# Setup Zsh with oh-my-zsh, plugins, and Powerlevel10k
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Setup .zshrc
ENV ZSH="/home/dev/.oh-my-zsh"
RUN cat <<EOF > ~/.zshrc
# THEME
export TERM="xterm-256color"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# PLUGINS
plugins=(
git
zsh-autosuggestions
zsh-history-substring-search
)
source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# SETTINGS
## Disable new user prompt.
zstyle ':zsh-newuser-install:*' disable true
EOF

# Generate SSH key for GitHub and add GitHub to known_hosts
RUN ssh-keygen -t ed25519 -C "Developer Environment" -f ~/.ssh/dev_key -N "" && \
    touch ~/.ssh/known_hosts && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts

# Entry command
CMD [ "zsh" ]
