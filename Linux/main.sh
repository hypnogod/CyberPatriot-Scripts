#!/bin/bash

# hypnogod

update() {
    echo "start updates"
    echo "You might Lose points for SSH (while update is going on)"
    pause
    sudo apt-get update -y
    wait
    sudo apt-get upgrade -y
    wait
    sudo apt-get dist-upgrade -y
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
    pause
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

}

firewall() {
    echo "Enable fire wall"
	sudo ufw enable
}

changePasswordForall() {
    echo "changing everyones password like this is not safe method"
    pause
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
}
# FR = Future Reference
#Credit/FR: https://arkit.co.in/3-shell-scripts-change-multiple-users-password/

findbadFiles() {
    echo "find common files"
    for commonFile in mp3 wav mp4 gif jpg png img jpeg webvm
    do 
        sudo find /home -name *.$commonFile
    done
}

findBadTools() {
    echo "Find Hacking tools"
    for commanHackingtools in hydra john nikto netcat nmap burp wireshark kismet sqlmap zenmap metasploit   
    do
        echo "do you want to remove: $commanHackingtools ? (y/n)"
        read hackinginput
        if [$hackinginput == "y"] 
            then 
                sudo apt-get remove $commanHackingtools
            fi
    done
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
}

