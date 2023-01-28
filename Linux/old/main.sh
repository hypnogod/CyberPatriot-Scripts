#!/bin/bash

# hypnogod
# pam file done

thingsToDO() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "TODO && Advice: "
    echo "1) Do the forensic"
    echo "2) Check for malwares"
    echo "3) manage accounts (add, delete users, change permitions)"
    echo "4) Delete Suspicious files"
    echo "5) Enable Firewall"
    echo "6) check Services and networks"
    echo "7) Installing and Automating Updates (daily)"
    echo "8) Setting Audit Policies"
    echo "9) PAM/Config Files"
    echo "10) TO find hacking tools go to Ubuntu software center"
    echo "11) TO manage users go to user accounts in settings"
    echo "12) Change the password and account lockout policies"
    echo "13) Change the settings for firefox"
    echo "14) Look at the System Log (Similar to Windows Event Viewer)"
    echo "15) look at the audit settings"
    echo "16) Restart your comp at last (don't forget to take a Picture first)"
    echo "17) Find files and change their file permissions (chmod o-r <file>)"
    echo
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    read -p "Press any key to continue "
}

update() {
    clear
    echo "start updates"
    echo "You might Lose points for SSH (while update is going on)"
    read -p "Press any key to continue "
    sudo apt-get update -y
    wait
    sudo apt-get upgrade -y
    wait
    sudo apt-get dist-upgrade -y
    wait
    sudo dpkg-reconfigure --priority=low unattended-upgrades
    wait
    sudo apt-get install -f -y
    wait
    sudo apt-get autoremove -y
    wait
    sudo apt-get autoclean -y
    wait
    sudo apt-get install unattended-upgrades
    sudo dpkg-reconfigure -plow unattended-upgrades
    wait
    killall firefox
    wait
    sudo apt-get --purge --reinstall install firefox -y
    wait
    read -p "Press any key to continue "
}

removeServices() {
    clear
    echo "Remove FTP service? (y/n)"
    read ftpService
    if [ "$ftpService" == "y" ]; then
        sudo ufw deny ftp
        sudo ufw deny ftps-data
        sudo ufw deny ftps
        sudo ufw deny sftp
        sudo apt-get remove pure-ftpd
        sudo apt-get purge vsftpd -y -qq
        sudo apt-get purge ftp -y -qq
    elif [ "$ftpService" == "n" ]; then
        sudo ufw allow ftp
        sudo ufw allow sftp
        sudo ufw allow ftps-data
        sudo ufw allow ftps
        sudo service vsftpd restart
    fi
    read -p "Press any key to continue..."
    clear
    echo "Remove Samba? (y/n)"
    read sambaService
    if [ "$sambaService" == "y" ]; then
        sudo apt-get purge samba -y -qq
        sudo apt-get purge samba-common -y -qq
        sudo apt-get purge samba-common-bin -y -qq
        sudo apt-get purge samba4 -y -qq
    fi
    read -p "Press any key to continue..."
    clear
    echo "Remove telnet? (y/n)"
    read telnetService
    if [ "$telnetService" == "y" ]; then
        sudo ufw deny telnet
        sudo ufw deny rtelnet
        sudo ufw deny telnets
        sudo apt-get purge telnet -y -qq
        sudo apt-get purge telnetd -y -qq
        sudo apt-get inetutils-telnetd -y -qq
        sudo apt-get telnetd-ssl -y -qq
    elif [ "$telnetService" == "n" ]; then
        sudo ufw allow telnet
        sudo ufw allow rtelnet
        sudo ufw allow telnets
    fi
    read -p "Press any key to continue..."
    clear
    echo "Remove telnet? (y/n)"
    clear
    echo "Remove mailing service? (y/n)"
    read mailingServices
    if [ "$mailingServices" == "y" ]; then
        ufw deny imap2
        ufw deny imaps
        ufw deny pop3s
        ufw deny smtp
        ufw deny pop2
        ufw deny pop3
    elif [ "$mailingServices" == "n" ]; then
        ufw allow imap2
        ufw allow imaps
        ufw allow pop3s
        ufw allow smtp
        ufw allow pop2
        ufw allow pop3
    fi
    read -p "Press any key to continue..."
    clear
    sudo service --status-all | grep "[ + ]"
    echo "Check all active services"
    read -p "Press any key to exit..."
}

secureNetwork() {
    clear
    echo "do you want to enable firewall (y/n)"
    read eFirewall
    if [ "$eFirewall" == "y" ]; then
        echo "Enable fire wall"
        sudo ufw enable
        wait
        sudo ufw default deny incoming
        sudo apt-get install gufw
        echo "do you want to enable firewall (y/n)"
    fi
    read -p "Press any key to continue "
    echo "Do you want to secure /etc/sysctl.conf (y/n)"
    read synCookie
    if [ "$synCookie" == "y" ]; then
        echo "Securing /etc/sysctl.conf"
        echo -e "\nLooping through a file"
        while read p; do
            sudo sysctl -w $p
        done <sysctlSecureNetwork.txt
        # https://www.techrepublic.com/article/how-to-properly-secure-sysctl-on-linux/
        # Other good resources:
        # https://www.linuxquestions.org/questions/red-hat-31/disabling-ipv4-packet-forwarding-net-ipv4-ip_forward-%3D-0-centos-5-5-a-841289/
    fi
    read -p "Press any key to continue "
    echo "Do you want to (Potentially harmful) Disable IPv6 (y/n)"
    read disableIPv6
    if [ "$disableIPv6" == "n" ]; then
        echo "Disable IPv6"
        echo 'net.ipv6.conf.all.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
        echo 'net.ipv6.conf.default.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
        echo 'net.ipv6.conf.lo.disable_ipv6 = 1' | sudo tee -a /etc/sysctl.conf
    fi
    read -p "Press any key to continue "
    echo "do you want to prevent Prevent IP Spoofing (y/n)"
    read disIPSpoofing
    if [ "$disIPSpoofing" == "y" ]; then
        echo "Prevent IP Spoofing"
        echo "nospoof on" | sudo tee -a /etc/host.conf
        echo "order bind,hosts" | sudo tee -a /etc/host.conf
        echo "multi on" | sudo tee -a /etc/host.conf
        wait
        echo "Please go to /etc/host.conf to check everything"
        read -p "Press any key to continue "
    fi
    read -p "Press any key to continue"
    echo "do you want to setup IPtables (y/n)"
    read IPtables
    if [ "$IPtables" == "y" ]; then
        sudo apt-get install iptables -y -qq

    fi
    echo "Check all services"
    read -p "Press any key to continue "
}
# not the best way to write a code
# you can use one variable if set an smthing like type in 1 to enable firewall

changePasswordForall() {
    clear
    echo "changing everyones password like this is not safe method"
    echo "You must be a root user to run this code"
    read -p "Press any key to continue "
    echo "type in 'auto' if you want it do automatically change password for all users"
    echo "type in 'file' if you want to change password for selected few"
    echo "type in your options: "
    read managePasswd
    if [ "$managePasswd" == "auto" ]; then
        echo "auto is currently down"
        #while IFS=: read u x nn rest; do if [ $nn -ge 1000 ]; then echo 'StrongPassw0rd!' | passwd --stdin $u; fi; done </etc/passwd
    elif [ "$managePasswd" == "file" ]; then
        echo "if there is any error it might be your input of version of linux (please manually hange the script)"
        echo "Give a list of users (make sure there is space in between each user)"
        echo " if there is an error run: [sudo mount -o remount,rw / ] "
        echo "please type in the list: "
        read userList
        for i in $userList; do
            echo $i
            echo "$i:StrongPassw0rd!" | chpasswd

        done
    fi
    read -p "Press any key to continue "
}
# FR = Future Reference
#Credit/FR: https://arkit.co.in/3-shell-scripts-change-multiple-users-password/

findbadFiles() {
    clear
    echo "find common files"
    for commonFile in mp3 mp4 wav m4a mov wnv wpl gif jpg png img jpeg webvm; do
        sudo find /home -name *.$commonFile
    done
    read -p "Press any key to continue "
}

findBadTools() {
    clear
    echo "Find Hacking tools"
    for commanHackingtools in hydra john nikto netcat nmap burp wireshark kismet sqlmap zenmap metasploit ettercap hashcat; do
        echo "do you want to remove: $commanHackingtools ? (y/n)"
        read hackinginput
        if [ "$hackinginput" == "y" ]; then
            sudo apt-get -y purge $commanHackingtools*
        fi
    done
    read -p "Press any key to continue "
}

openSSh() {
    clear
    echo -n "OpenSSH Server [y/n] "
    read sshOption
    if [ "$sshOption" == "y" ]; then
        sudo apt-get -y install openssh-server
        sudo ufw allow ssh
        sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
        wait
        clear
        echo "backup of current ssh config in /etc/ssh/sshd_config.bak"
        read -p "Press any key when finished"
        echo "Looping through a file"
        while read a; do
            echo "$a" | sudo tee -a /etc/ssh/sshd_config
        done <sshdConfigCommands.txt
        # https://octopus.com/docs/runbooks/runbook-examples/routine/hardening-ubuntu
        read -p "Press any key to continue"
        clear
        sudo cat /etc/ssh/sshd_config
        read -p "Check if everything looks fine (comments, changes, etc)"
        sudo service ssh restart
    elif [ "$sshOption" == "n" ]; then
        sudo apt-get -y purge openssh-server*
        sudo ufw deny ssh
        echo "shh has been disabled and purged"
    fi
    read -p "Press any key to continue "
}

commonPasswordFunc() {
    #/etc/pam.d/common-password
    echo "Installing libpam-cracklib..."
    sudo apt-get -y install libpam-cracklib
    wait
    echo "Location: /etc/pam.d/common-password"
    echo "add ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 in line with pam_cracklib.so"
    sudo sed -i 's/pam_cracklib.so retry=3 minlen=8/pam_cracklib.so retry=3 minlen=8 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/g' /etc/pam.d/common-password
    echo "add remember=5 and minlen=8 to end of line that has pam_unix.so"
    sudo sed -i 's/pam_unix.so obscure use authtok/pam_unix.so obscure use authtok sha512 remember=5 minlen=8/g' /etc/pam.d/common-password
    wait
    sudo gedit /etc/pam.d/common-password
    read -p "Please check if everything looks good"
}

lightdmConfigFunc() {
    #/etc/lightdm/lightdm.conf
    echo "Location: /etc/lightdm/lightdm.conf"
    echo "allow-guest=false in /etc/lightdm/lightdm.conf"
    echo -e '[SeatDefaults]\nallow-guest=false\ngreeter-hide-users=true\ngreeter-show-manual-login=true' >>/etc/lightdm/lightdm.conf
    sudo chmod 644 /etc/lightdm/lightdm.conf
    wait
    sudo gedit /etc/lightdm/lightdm.conf
    read -p "Please check if everything looks good"
}

loginDefConfigFunc() {
    # /etc/login.defs
    echo "Location: /etc/login.defs"
    echo "Max password, min password and pass warn age"
    sudo sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   90' /etc/login.defs
    sudo sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   10' /etc/login.defs
    sudo sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs
    wait
    sudo gedit /etc/login.defs
    read -p "Please check if everything looks good"
}

commonAuthFunc() {
# /etc/pam.d/common-auth
    echo "Location: /etc/pam.d/common-auth"
    echo "add auth required pam_tally2.so deny=5 unlock_time=1800 to the end of the file"
    sudo echo 'auth required pam_tally.so deny=5 unlock_time=1800 onerr=fail audit even_deny_root_account silent' >>/etc/pam.d/common-auth
    wait
    sudo gedit /etc/pam.d/common-auth
    read -p "Please check if everything looks good"
}

otherPamDconfigFunc() {
    # /etc/pam.d/other
    echo "Location: /etc/pam.d/pam.d/other"
    echo "Kinder configuration"
    echo "auth	required	pam_unix.so" | sudo tee -a /etc/pam.d/other
    echo "auth	required	pam_warn.so" | sudo tee -a /etc/pam.d/other
    echo "account	required	pam_unix.so" | sudo tee -a /etc/pam.d/other
    echo "account	required	pam_warn.so" | sudo tee -a /etc/pam.d/other
    echo "password	required	pam_deny.so" | sudo tee -a /etc/pam.d/other
    echo "password	required	pam_warn.so" | sudo tee -a /etc/pam.d/other
    echo "session	required	pam_unix.so" | sudo tee -a /etc/pam.d/other
    echo "session	required	pam_warn.so" | sudo tee -a /etc/pam.d/other
    #https://tldp.org/HOWTO/User-Authentication-HOWTO/x263.html
    read -p "Press any key to exit.."
}
editConfig() {
    clear
    #/etc/lightdm/lightdm.conf
    lightdmConfigFunc

    # /etc/login.defs
    loginDefConfigFunc

    #/etc/pam.d/common-password
    commonPasswordFunc

    # /etc/pam.d/common-auth
    commonAuthFunc

    # /etc/pam.d/other
    otherPamDconfigFunc
}

setAudit() {
    echo "Setting Audit policies"
    sudo apt-get install auditd
    sudo auditctl -e 1
    wait
    echo "Location: /etc/audit/auditd.conf"
    sudo gedit /etc/audit/auditd.conf
    read -p "Press any key to exit.."
}

filePermitions() {
    echo "Setting file permitions"
    echo "use <ls -l > to view permitions"
    sudo apt-get install chmod
    sudo chown root:root /etc/shadow
    sudo chmod 700 /etc/shadow

    echo "Please check the file permition of /etc/shadow"
    read -p "Press any key to continue..."
    echo "cron setup"
    echo "backing up crontab in <old_crontab.backup> file"

    sudo crontab -l >old_crontab.backup
    sudo crontab -r
    cd /etc/
    sudo /bin/rm -f cron.deny at.deny
    sudo echo root >cron.allow
    sudo echo root >at.allow
    sudo /bin/chown root:root cron.allow at.allow
    sudo /bin/chmod 644 cron.allow at.allow

    echo "File location /etc/sudoers"
    sudo cat /etc/sudoers
    echo "Please check the file above"
    read -p "Press any key to continue..."

    clear
    echo ""
    read -p "Press any key to continue..."

}

menu() {
    clear
    echo "These options are not in order"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) List of things that needed to be done (checklist)"
    echo "2) Update linux system (ubuntu/debian)"
    echo "3) Remove bad services (ftp)"
    echo "4) Secure network (enable fire wall, etc)"
    echo "5) Change all password at once"
    echo "6) Find useless files"
    echo "7) Find/remove hacking tools"
    echo "8) Manage ssh (enable or disable)"
    echo "9) Manage PAM files (configs)"
    echo "10) Audit Policies"
    echo "11) File permitions"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Please choose an option (number): "
    read initialInput
    if [ "$initialInput" == "1" ]; then
        thingsToDO
    elif [ "$initialInput" == "2" ]; then
        update
    elif [ "$initialInput" == "3" ]; then
        removeServices
    elif [ "$initialInput" == "4" ]; then
        secureNetwork
    elif [ "$initialInput" == "5" ]; then
        changePasswordForall
    elif [ "$initialInput" == "6" ]; then
        findbadFiles
    elif [ "$initialInput" == "7" ]; then
        findBadTools
    elif [ "$initialInput" == "8" ]; then
        openSSh
    elif [ "$initialInput" == "9" ]; then
        editConfig
    elif [ "$initialInput" == "10" ]; then
        setAudit
    elif [ "$initialInput" == "11" ]; then
        filePermitions
    fi
}

menu
