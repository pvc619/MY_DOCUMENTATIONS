#!/bin/bash

# Update package information
sudo apt update

# Install software-properties-common
sudo apt install -y software-properties-common

# Add Ansible repository and update
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install -y ansible

