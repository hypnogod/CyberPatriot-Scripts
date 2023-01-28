#!/bin/bash

becho() {
    local arg2=${2:-" "}  # Set default value for $2 to " "
    printf "\n"
    if [ "$arg2" = " " ]; then
        echo -e "$(tput setaf 1)$1$(tput sgr0)"
        # echo -e "$1"
    else
        echo -n "$(tput setaf 1)$1$(tput sgr0)"
    fi
}

becho "Hostname:"
cat /etc/hostname

becho "Timezone:"
ls -ln /etc/localtime

becho "OS INFO:"
cat /etc/*-release

becho "Kernel Info:"
uname -a


becho "IP Config:"
if command -v ifconfig &> /dev/null; then
    ifconfig
else
    ip a
fi

becho "Displaying Listening TCP Connections:"
netstat -aptln

becho "Displaying Listening UDP Connections:"
netstat -apuln

becho "Viewing Hostname-to-IP Address Mappings:"
cat /etc/hosts
lsattr /etc/hosts

becho "Viewing DNS Resolution Settings:"
cat /etc/resolv.conf
lsattr /etc/resolv.conf

becho "Check 600 File Permission:"
ls -la /etc/shadow
lsattr /etc/shadow

ls -la /etc/gshadow
lsattr /etc/gshadow

becho "Check 644 File Permission:"
ls -la /etc/passwd
lsattr /etc/passwd

ls -la /etc/group
lsattr /etc/group

becho "Check 440 File Permission:"
ls -la /etc/sudoers
lsattr /etc/sudoers

becho "Check non-root owned File in /etc"
find /etc/ -not -user root

becho "Current Status of /tmp:"
ls -la /tmp
lsattr /tmp

becho "Current Status of /var/tmp:"
ls -la /var/tmp
lsattr /var/tmp

becho "List current user (w)"
w

becho "Timeline of boot and recent access"
who -a

becho "IP addresses of the last several logons"
last

becho "Check crontab:"
if command -v crontab &> /dev/null; then
    for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l; done
fi


becho "Sudoers Config:"
cat /etc/sudoers /etc/sudoers.d/* | grep -v "^# " | sed '/^$/N;/^\n$/D'

becho "Services (systemctl)"
if command -v systemctl &> /dev/null; then
    systemctl list-units --type=service
fi

becho "Services (service or /etc/init.d/*)"
if command -v service &> /dev/null; then
    service --status-all
else
    ls -l /etc/init.d/*
fi

becho "Users with id of 0"
awk -F: '($3=="0"){print}' /etc/passwd

becho "Users with .ssh files"
find /home -type d -name ".ssh"
find /root -type d -name ".ssh"

becho "Amount of disk space available"
df -h

read -p "Press any key to start the backup process...."
# Backup Dir
mkdir -p /audit/backup
chown -R root:root /audit
chmod -R 600 /audit
backup_dir="/audit/backup"

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

becho "Backup ps aux --forest"
ps aux --forest > "$backup_dir/ps.aux.forest.$timestamp.txt"

becho "Backup /usr/bin list (Not the binary)"
ls -la /usr/bin/ > "$backup_dir/usr.bin.$timestamp.txt"

becho "Backup /usr/sbin list (Not the binary)"
ls -la /usr/sbin/ > "$backup_dir/usr.sbin.$timestamp.txt"

becho "Backup /home list (Not the binary)"
ls -la /home > "$backup_dir/home.$timestamp.txt"


read -p "Press any key to backup /etc folder (pls check your storage)...."

# To view the tar backup (untar): tar -xzf your_archive.tar.gz -C /path/to/destination_directory
becho "Backup /etc"
tar -czvf "$backup_dir/etc_backup_$timestamp.tar.gz" /etc

chmod -R 600 /audit
