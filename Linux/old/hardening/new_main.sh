#!/bin/bash

change_root_pass() {
    # Change root password
    echo "";
    echo "Do you want to change root password? (y/n): ";
    read root_password;
    echo "";
    if [ "$root_password" == "y" ]; then
        printf "\033[1;31mChanging root password...\033[0m\n"
        passwd root;
    fi
}

set_permission() {
    # Permission read & write bash history of the root user
    echo ""
    echo "Do you want to set file permission? (y/n): "
    read file_perm
    echo ""
    if [ "$file_perm" == "y" ]; then
        printf "\033[1;31mSecuring Files...\033[0m\n"
        
        echo "Read & Write permission for bash_history: "
        chmod 600 ~/.bash_history
        chown root:root ~/.bash_history
        echo ""
        
        echo "Permission for /etc/passwd"
        # everyone can read, but only root can write
        chmod 644 /etc/passwd
        chown root:root /etc/passwd
        echo ""
        
        echo "Permission for /etc/shadow"
        chmod 600 /etc/shadow
        chown root:root /etc/shadow
        echo ""
        
        echo "Permission on the "group" file"
        chmod 644 /etc/group
        chown root:root /etc/group
        echo ""
        
        echo "Permission on the "gshadow" file (group/user permission)"
        chmod 600 /etc/gshadow
        chown root:root /etc/gshadow
        
        clear
        
        echo "Cron Dir"
        ls -la /etc | grep cron
        read -p "Press any key to continue..."
        echo ""
        
        echo "Permission on crontab"
        chown root:root /etc/crontab
        chmod 644 /etc/crontab
        echo ""
        
        echo "Set permission on all system crontab directories"
        chown -R root:root /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly
        chmod -R go-rwx cron.hourly cron.daily cron.weekly cron.monthly cron.d
        echo ""
        
        echo "Restrict the permissions on the spool directory for user crontab files"
        chown root:root /var/spool/cron
        chmod -R go-rwx /var/spool/cron
        echo ""
        
        echo "Cron Dir"
        ls -la /etc | grep cron
        read -p "Press any key to continue..."
    fi
    
}

secure_ssh () {
    # Secure ssh
    echo "Secure ssh? (y/n): "
    read sec_ssh
    echo ""
    if [ "$sec_ssh" == "y" ]; then
        printf "\033[1;31mSecuring ssh...\033[0m\n"
        
        echo "Changing the owner of sshd_config to root"
        chown root:root /etc/ssh/sshd_config
        wait
        echo ""
        
        echo "Making sure only owner (root) can read and write"
        chmod 600 /etc/ssh/sshd_config
        wait
        echo ""
        
        echo "Creating a backup file..."
        cp /etc/ssh/sshd_config /etc/ssh/.backup.sshd_config
        wait
        echo ""
        
        echo "creating a user for business partners (with sudo privilege)"
        echo ""
        echo "username will be myRandomCoolUser1"
        sudo adduser myRandomCoolUser1 sudo
        sudo passwd myRandomCoolUser1
        
        echo ""
        read -p "Make sure to inform Business Partners..."
        echo ""
        
        clear
        echo "Add [ X11Forwarding no ]"
        echo "Add [ AllowAgentForwarding no ]"
        echo "Add [ AllowUsers myRandomCoolUser1 ]"
        echo "Add [ PermitRootLogin no ]"
        echo "Add [ Port 6771 ]"
        read -p "Press any key to edit the sshd_file.."
        vim /etc/ssh/sshd_config
        echo ""
        read -p "Press any key to restart ssh"
        systemctl restart sshd.service
    fi
}

secure_apache() {
    echo "Secure Apache? (y/n): "
    read sec_apache
    echo ""
    if [ "$sec_apache" == "y" ]; then
        printf "\033[1;31mSecuring Apache...\033[0m\n"
        chown -R root:root /etc/apache2
        chown -R root:root /etc/apache
        
        if [ -e /etc/apache2/apache2.conf ]; then
            echo "Creating a backup config file..."
            cp /etc/apache2/apache2.conf /etc/apache2/.backup.apache2.conf
            echo ""
            
            echo "Setting up permissions"
            echo ""
            echo "<Directory />" >> /etc/apache2/apache2.conf
            echo "        AllowOverride None" >> /etc/apache2/apache2.conf
            echo "        Order Deny,Allow" >> /etc/apache2/apache2.conf
            echo "        Deny from all" >> /etc/apache2/apache2.conf
            echo "</Directory>" >> /etc/apache2/apache2.conf
            echo "UserDir disabled root" >> /etc/apache2/apache2.conf
            echo "permission completed"
            echo ""
        fi
        read -p "Press any key to restart apache2"
        systemctl restart apache2.service
    fi
}

check_all_ports() {
    echo "Do you want to check all ports? (y/n): "
    read check_ports
    echo ""
    if [ "$check_ports" == "y" ]; then
        printf "\033[1;31mChecking All Ports...\033[0m\n"
        if [ "$(which ss)" == "/usr/bin/ss"]
        then
            ss -lntu >> port_info.txt
        else
            netstat -lnt | awk "NR>2{print $4}" | grep -E "(0.0.0.0:|:::)" | sed "s/.*://" | sort -n | uniq >> port_info.txt
        fi
        wait
    fi
    read -p "Press any key to continue..."
}

update() {
    echo ""
    echo "Do you want to update & upgrade the system? (y/n): "
    read check_system_update
    echo ""
    if [ "$check_system_update" == "y" ]; then
        printf "\033[1;31mStarting update & upgrade...\033[0m\n"
        apt-get update -y
        wait
        apt-get upgrade -y
        wait
    fi
}

setFirewall() {
    read -p "Make sure to update your computer first..."
    echo "Do you want to set up firewall? (y/n): "
    read check_firewall
    echo ""
    if [ "$check_firewall" == "y" ]; then
        apt install ufw
        wait
        systemctl status ufw
        wait
        read -p "check everything..."
        printf "\nRunning Default rules..."
        ufw default allow outgoing
        wait
        ufw default deny incomming
        wait
        
        while :
        do
            echo "Type port for all required services..."
            printf "\033[1;31mWhat is the port number you want to allow?: \033[0m\n"
            echo ""
            read fire_port
            
            ufw enable $fire_port
            
            echo "Do you want to exit (y/n)? "
            read fire_exit
            if [ "$fire_exit" == "y" ]; then
                break
            fi
        done
        clear
        ufw status
        printf "You can run:\nufw status numbered\nufw delete [number]\n"
        printf "ufw allow from <<ip>> to any port <<port number>> proto <<tcp>>\n"
        read -p "check everything..."
        ufw enable
        
        
    fi
}

menu() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) Change Root Password"
    echo "2) Set File Permissions"
    echo "3) Secure SSH"
    echo "4) Secure Apache"
    echo "5) Check All Ports"
    echo "6) Update and Upgrade"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Please choose an option (number): "
    read initialInput
    if [ "$initialInput" == "1" ]; then
        ;
        printf "\nChange other users password too\n"
        read -p "Press any key to continue..."
        elif [ "$initialInput" == "2" ]; then
        set_permission
        elif [ "$initialInput" == "3" ]; then
        secure_ssh
        elif [ "$initialInput" == "4" ]; then
        secure_apache
        elif [ "$initialInput" == "5" ]; then
        check_all_ports
        elif [ "$initialInput" == "6" ]; then
        update
    fi
}

main() {
    clear
    echo ""
    echo "Welcome $(whoami)"
    
    # Become root if not already
    if [ "$(whoami)" != "root" ]; then
        echo "Become a root user..."
        sudo su
    fi
    
    echo "do you want to run teamaux command (y/n): "
    read start_teamaux
    if [ "$start_teamaux" == "y" ]; then
        echo "Your Name: "
        read NAME
        tmux attach -t "$NAME"
        echo ""
    fi
}

main