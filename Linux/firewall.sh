
set_up_firewall() {
    # To list the rules of the current iptables
    iptables -L --line-numbers | tee -a prev_iptable.log
    # Install ufw
    printf "Install ufw"
    apt install ufw

    printf "ufw status"
    ufw status | tee -a ufw_status.log
    
    printf "Disable ufw"
    ufw disable

    printf "Reset all rules"
    ufw reset

    printf "Disable firewall"
    systemctl stop ufw

    printf "vim /etc/default/ufw"

    ufw default deny incoming

    ufw default allow outgoing

    ufw allow 22
    ufw allow 80
    ufw allow 443

    systemctl start ufw 

    ufw enable

    ufw status
}

touch firewall_set_up.log
set_up_firewall | tee -a firewall_set_up.log