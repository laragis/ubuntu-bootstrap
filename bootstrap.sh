#!/bin/bash

if [ $(id -u) -ne 0 ]; 
  then echo "Ubuntu dev bootstrapper, APT-GETs all the things -- run as root...";
  exit 1; 
fi

apt-get update
# apt-get upgrade -y

################################################################################
# Basic & Advanced
################################################################################

basic_setup(){
  apt install -y \
    curl wget \
    telnet iputils-ping \
    git vim
}

advanced_setup(){
  apt install -y \
    htop exa bat ncdu tldr

  # Install fzf fd
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  echo 'y' | ~/.fzf/install

  # Install duf
  wget -P /tmp https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_amd64.deb
  dpkg -i /tmp/duf_0.8.1_linux_amd64.deb && rm -rf /tmp/duf_0.8.1_linux_amd64.deb
}

################################################################################
# Sd
################################################################################

sd_setup(){
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  echo -n '\n source "$HOME/.cargo/env"' >> ~/.zshrc
  exec zsh
  cargo install sd
}

################################################################################
# Zsh
################################################################################

zsh_setup(){
    # Install Zsh
    apt install -y zsh
    # Switch from bash to zsh
    chsh -s $(which zsh)
}

ohmyzsh_setup(){
    # Install Oh My Zsh
    echo "y" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

zinit_setup(){
  # Install Zinit
  echo "y" | bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

  # Add packages and snippets
  tee -a ~/.zshrc <<EOF

# Packages
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light agkozak/zsh-z

# Snippet
zinit snippet https://raw.githubusercontent.com/laragis/ubuntu-bootstrap/main/aliases.sh
EOF

  # Reload Zsh
  exec zsh
}

################################################################################
# Git
################################################################################

git_setup(){
  git config --global user.email "ttungbmt@gmail.com"
  git config --global user.name "Truong Thanh Tung"
}

################################################################################
# SSH
################################################################################

ssh_setup(){
  ssh-keygen -t rsa -b 4096 -C "ttungbmt@gmail.com"
}

################################################################################
# Final
################################################################################

basic_setup
advanced_setup
zsh_setup
ohmyzsh_setup
zinit_setup
