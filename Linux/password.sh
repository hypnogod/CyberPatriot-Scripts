# Change Password ()


# https://github.com/ucrcyber/CCDC/blob/master/blue-team/linux/changePasswords.sh

change_password() {
    echo ""
    for user in $(awk -F: '$7 ~ /(\/.*sh)/ { print $1 }' /etc/passwd)
    do
        passwd -S "$user"
        echo "" # // spacing
        id "$user" | awk '{ split($0,a," "); print a[1] "\n\n" a[2] "\n\n" a[3] }'
        echo ""
        echo "Do you want to change passwords? (y/n): ";
        read user_response;
        if [ "$user_response" == "y" ]; then
            passwd "$user"
        fi
        printf "\n--------------------------------\n"
    done
}

touch change_pass.log
change_password | tee -a change_pass.log
