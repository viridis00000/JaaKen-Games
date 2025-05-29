FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy all contents from host to container
COPY . /app

# Set working directory
WORKDIR /app

# Install yq
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

# Install apt packages
RUN apt-get install -y $(yq eval '.apt_packages | join(" ")' /app/.devcontainer/setup_settings.yaml)

# Setup zsh
RUN chsh -s /usr/bin/zsh root && \
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true && \
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc && \
    apt install -y fonts-powerline locales && \
    locale-gen en_US.UTF-8

# Setup vscode and shell-integration
RUN apt-get install wget gpg && \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg && \
    rm -f packages.microsoft.gpg && \
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get update && \
    apt-get install -y code && \
    echo `[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh --user-data-dir='.' --no-sandbox)"` >> ~/.zshrc

# Setup direnv
RUN  echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc && \
    echo 'source_env() { eval "$(direnv stdlib)"; source_env "$@"; }' >> ~/.zshrc && \
    echo 'export DIRENV_LOG_FORMAT=""' >> ~/.zshrc && \
    echo 'direnv allow /app' >> ~/.zshrc
RUN direnv allow

# Add /app directory to git safe repositories
RUN git config --global --add safe.directory /app
