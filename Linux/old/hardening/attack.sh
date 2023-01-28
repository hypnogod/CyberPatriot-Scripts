


guess_ssh() {

    printf "\nGetting low hanging fruit.\nSSH using given root password\n"
    echo "Start simple ssh login..."

    while :
    do
        echo "Give USERNAME: "
        read username
        echo "Give SSH PORT: "
        read TEST_PORT
        ssh "$username@$1" -p "$TEST_PORT" 
        wait
        echo "Do you want to exit (y/n)? "
        read low_exit
        if [ "$low_exit" == "y" ]; then
            break
        fi
    done
}

brute_force_ssh() {
    echo "Starting brute force ssh"
    msfconsole -q -x "use auxiliary/scanner/ssh/ssh_enumusers;set RHOST $1; run; exit;"
    wait

    # echo "Brute force SSH (y/n): "
    # read start_hydra
    # echo ""
    # if [ $start_hydra == "y" ]; then
    #     echo "PATH: user wordlist: "
    #     read hydra_user_wordlist
    #     echo ""

    #     echo "PATH: password wordlist: "
    #     read hydra_pass_wordlist
    #     echo ""

    #     printf "\033[1;31mStarting hydra...\033[0m\n"
    #     hydra -L $hydra_user_wordlist -P $hydra_pass_wordlist $TARGET ssh
    #     wait
    #     read -p "Press any key to continue..."
    # fi
    # clear
    # echo ""
}

scan_ssh_port() {
    echo ""
    echo "Give SSH PORT: "
    read SCAN_PORT_SSH
    nmap -p"$SCAN_PORT_SSH" "$1" -sC >> get_ssh_info.txt # Send default nmap scripts for SSH
    nmap -p"$SCAN_PORT_SSH" "$1" -sV >> get_ssh_info.txt # Retrieve version
    nmap -p"$SCAN_PORT_SSH" "$1" --script ssh2-enum-algos >> get_ssh_info.txt # Retrieve supported algorythms 
    nmap -p"$SCAN_PORT_SSH" "$1" --script ssh-hostkey --script-args ssh_hostkey=full # Retrieve weak keys
    nmap -p"$SCAN_PORT_SSH" "$1" --script ssh-auth-methods --script-args="ssh.user=root" # Check authentication methods
}

scan_ip_nmap() {
    echo "Start NMAP scan (y/n): "
    read start_nmap
    echo ""
    if [ "$start_nmap" == "y" ]; then
        printf "\033[1;31mStarting nmap scan...\033[0m\n"
        nmap -T4 -A -v -p- $1 >> nmap_result.txt
        wait
        cat nmap_result.txt
        read -p "Press any key to continue..."
    fi
    echo ""
    clear
}

start_ftp_exploit() {
    echo "Start FTP Metaexploit (y/n): "
    read start_ftp_meta
    echo ""
    if [ "$start_ftp_meta" == "y" ]; then
        printf "\033[1;31mStarting metaexploit...\033[0m\n"

        echo "Checking for anonymous user"
        msfconsole -q -x "use auxiliary/scanner/ftp/anonymous;set RHOST $1; run; exit;"
        wait
        read -p "Press any key to continue..."

        # run ftp in browser
        echo "Do you want to run ftp in browser (y/n): "
        read ftp_browser
        if [ "$ftp_browser" == "y" ]; then
            echo "ftp://anonymous:anonymous@$1"
            read -p "Press any key to continue..."
        fi

        echo  "https://book.hacktricks.xyz/network-services-pentesting/pentesting-ftp"
    fi
}

search_exploits() {
    echo ""
    echo "Search Exploits"
    echo "https://book.hacktricks.xyz/generic-methodologies-and-resources/search-exploits"
    read -p "Press any key to continue..."
}

scan_sql() {
    echo ""
    echo "MySQL PORT: "
    read mysql_port
    nmap --script=mysql-databases.nse,mysql-empty-password.nse,mysql-enum.nse,mysql-info.nse,mysql-variables.nse,mysql-vuln-cve2012-2122.nse "$1" -p "$mysql_port" >> my_sql.txt
    read -p "Press any key to continue..."
}

menu() {
    TARGET="$1"
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) Guess SSH Password"
    echo "2) Brute Force SSH"
    echo "3) Scan SSH (nmap)"
    echo "4) Scan the network (nmap)"
    echo "5) Start FTP exploit"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Please choose an option (number): "
    read attack_input
    if [ "$attack_input" == "1" ]; then
        guess_ssh "$TARGET" # no 1
    elif [ "$attack_input" == "2" ]; then
        brute_force_ssh "$TARGET" # no 2
    elif [ "$attack_input" == "3" ]; then
        scan_ssh_port "$TARGET" # no 3
    elif [ "$attack_input" == "4" ]; then
        scan_ip_nmap "$TARGET" # no 4
    elif [ "$attack_input" == "5" ]; then
        start_ftp_exploit "$TARGET" # no 5
    elif [ "$attack_input" == "6" ]; then
        scan_sql "$TARGET" # no 6
    elif [ "$attack_input" == "7" ]; then
        search_exploits 
    fi
}

main() {

    echo "Get ip addresses: "
    read IP
    menu "$IP"

    # echo "Apache Exploit (y/n): "
    # read start_apache_exploit
    # echo ""
    # if [ $start_apache_exploit == "y" ]; then
    #     # active dir traversal
    #     # 
    #     echo ""
    # fi


}