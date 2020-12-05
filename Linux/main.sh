#!/bin/bash

# hypnogod

# funtion is not called in proper way
# fi will be at the end 
# if () else {} fi
#
  


thingsToDO() {
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "things to DO: "
echo "1) Do the forensic"
#done by the user
echo "2) Check for malwares"

echo "3) manage accounts (add, delete users)"
echo "4) Delete Suspicious files"
echo "5) Enable Firewall"
echo "6) check Services and networks"
echo "7) Installing and Automating Updates"
echo "8) Setting Audit Policies"
echo "9) PAM Files"
echo "10) Restart your comp at last (don't forget to take a Picture first)"
echo 
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
read -p "Press any key to continue "
}

update() {
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
    killall firefox
    wait
    sudo apt-get --purge --reinstall install firefox -y
    wait
    read -p "Press any key to continue "
}

removeServices() {
    echo "Remove FTP service? (y/n)"
	read ftpService
    if [ $ftpService =="y" ]
            then
                sudo ufw deny ftp 
                sudo ufw deny ftps-data 
                sudo ufw deny ftps
                sudo ufw deny sftp 
                sudo apt-get remove pure-ftpd
                sudo apt-get purge vsftpd -y -qq
            fi

        elif [$ftpService =="n"]
            then 
                sudo ufw allow ftp 
                sudo ufw allow sftp 
                sudo ufw allow ftps-data 
                sudo ufw allow ftps
                sudo service vsftpd restart
            fi
    read -p "Press any key to continue "
}

secureNetwork() {
    echo "do you want to enable firewall (y/n)"
    read eFirewall
    if [$eFirewall == "y"]
        then 
            echo "Enable fire wall"
	        sudo ufw enable
        fi
    read -p "Press any key to continue "
    echo "Do you want to enable syn cookie protection (y/n)"
    read synCookie
    if [$synCookie == "y"]
        then 
            echo "Enable syn cookie protection"
            sysctl -n net.ipv4.tcp_syncookies
        fi
    read -p "Press any key to continue "
    echo "Do you want to (Potentially harmful) Disable IPv6 (y/n)"
    read "disableIPv6"
    if [$disableIPv6 == "n"]
        then 
            echo "Disable IPv6"
            echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
        fi
    read -p "Press any key to continue "
    echo "do you want to disable IP Forwarding (y/n)"  
    read disIPforward
    if [$disIPforward == "y"]
        then 
            echo "Disable IP Forwarding"
            echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward
        fi  
    read -p "Press any key to continue "
    echo "do you want to prevent Prevent IP Spoofing (y/n)"
    read disIPSpoofing
    if [$disIPSpoofing == "y"]
        then 
            echo "Prevent IP Spoofing"
            echo "nospoof on" | sudo tee -a /etc/host.conf
        fi
    echo "Check all services"
    read -p "Press any key to continue "
}
# not the best way to write a code
# you can use one variable if set an smthing like type in 1 to enable firewall

changePasswordForall() {
    echo "changing everyones password like this is not safe method"
    read -p "Press any key to continue "
    echo "type in 'auto' if you want it do automatically change password for all users"
    echo "type in 'file' if you want to change password for selected few"
    echo "type in your options: "
    read managePasswd
    if [$managePasswd == "auto"]
        then 
            while IFS=: read u x nn rest; do if [ $nn -ge 1000 ]; then echo 'StrongPassw0rd!' | passwd --stdin $u; fi done < /etc/passwd
        fi
        elif [$managePasswd == "file"]
            then 
                echo "if there is any error it might be your input of version of linux (please manually hange the script)"
                echo "Give a list of users (make sure there is space in between each user)"
                echo "please type in the list: "
                read userList
                for i in $userList
                do 
                    echo $i
                    echo "'Password@123'" | passwd --stdin "$i"
                done
            fi
    read -p "Press any key to continue "
}
# FR = Future Reference
#Credit/FR: https://arkit.co.in/3-shell-scripts-change-multiple-users-password/

findbadFiles() {
    echo "find common files"
    for commonFile in mp3 mp4 wav m4a mov wnv wpl gif jpg png img jpeg webvm
    do 
        sudo find /home -name *.$commonFile
    done
    read -p "Press any key to continue "
}

findBadTools() {
    echo "Find Hacking tools"
    for commanHackingtools in hydra john nikto netcat nmap burp wireshark kismet sqlmap zenmap metasploit ettercap hashcat 
    do
        echo "do you want to remove: $commanHackingtools ? (y/n)"
        read hackinginput
        if [$hackinginput == "y"] 
            then 
                sudo apt-get -y purge $commanHackingtools*
            fi
    done
    read -p "Press any key to continue "
}

openSSh() {
    echo -n "OpenSSH Server [y/n] "
    read sshOption
    if [$sshOption == "y"]
        then 
            sudo apt-get -y install openssh-server
            sudo ufw allow ssh
            sudo sed -i '/^PermitRootLogin/ c\PermitRootLogin no' /etc/ssh/sshd_config
            sudo service ssh restart
        fi
        elif [$sshOption == "n"]
            then 
                sudo apt-get -y purge openssh-server* 
                sudo ufw deny ssh
                echo "shh has been disabled and purged"
            fi  
    read -p "Press any key to continue "
}



editConfig() {
    echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
    wait
    sudo sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   90' /etc/login.defs
    sudo sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   10'  /etc/login.defs
    sudo sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs
    wait 

    sudo apt-get -y install libpam-cracklib
    wait
    sudo sed -i '1 s/^/password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\n/' /etc/pam.d/common-password
    
    read -p "Press any key to continue "
}


menu() {
clear
echo "These options are not in order"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "1) List of things that needed to be done (checklist)" 
echo "2) Update linux system (ubuntu/debian)"
echo "3) Remove bad services (ftp, etc)"
echo "4) Secure network (enable fire wall, etc)"
echo "5) Change all password at once"
echo "6) Find useless files"
echo "7) Find/remove hacking tools"
echo "8) Manage ssh (enable or disable)"
echo "9) Manage PAM files (config)"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "hello"
read initialInput
    if [$initialInput == 1]
        then 
            thingsToDO
        fi
        elif [$initialInput == 2]
            then 
                update
            fi
        elif [$initialInput == 3]
            then 
                removeServices
            fi
        elif [$initialInput == 4]
            then 
                secureNetwork
            fi
        elif [$initialInput == 5]
            then
                changePasswordForall
            fi 
        elif [$initialInput == 6]
            then
                findbadFiles
            fi
        elif [$initialInput == 7]
            then 
                findBadTools
            fi
        elif [$initialInput == 8]
            then 
                openSSh
            fi
        elif [$initialInput == 9]
            then 
                editConfig
            fi
}  

menu