#!/bin/bash

# https://linux-audit.com/audit-and-harden-your-ssh-configuration/

# printf "The server configuration file is located at /etc/ssh/sshd_config \n"
printf "SSH Status:\n"
systemctl status ssh.service
read -p "Press any key to continue "