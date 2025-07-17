#!/bin/bash
# Author: Arthur Cadore M. Barcella
# Github: arthurcadore

# Script to install docker and docker-compose packages: 

# Removing any previous docker installations
sudo apt-get remove docker docker-engine docker.io containerd runc

# Updating package repository and installing base packages
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl -y
sudo apt-get install gnupg-agent software-properties-common -y

# Adding docker GPG key to apt repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adding docker packages
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Installing Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Adding docker permissions to the current user:
sudo usermod -aG docker $USER

#======================================================================
# Installing Docker Compose:

# Creating a directory for compose content:
mkdir -p ~/.docker/cli-plugins

# Adding docker compose packages
curl -SL https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linuxx86_64 -o ~/.docker/cli-plugins/docker_compose

# Verifying docker compose version:
docker compose version