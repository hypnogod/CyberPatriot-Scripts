

# /etc/fstab

set_permission() {
    printf "\nDo you want to set file permission? (y/n): "
    read file_perm
    if [ "$file_perm" == "y" ]; then
        printf "\n\033[1;31mSecuring Files...\033[0m"

        # --------------------------------------------------

        FILE=/etc/passwd
        RES_PERMISSION=644
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/etc/shadow
        RES_PERMISSION=644
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------
        FILE=/etc/group
        RES_PERMISSION=644
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi
        
        # --------------------------------------------------
        FILE=/etc/gshadow
        RES_PERMISSION=600
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi
        
        # --------------------------------------------------


        FILE=/etc/crontab
        RES_PERMISSION=644
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------
        FILE=/etc/cron.hourly
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------
        
        FILE=/etc/cron.daily
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/etc/cron.weekly
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/etc/cron.monthly
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/var/spool/cron
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi
        
        # --------------------------------------------------

        FILE=/etc/login.defs
        RES_PERMISSION=644
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/etc/grub.conf
        RES_PERMISSION=og-rwx
        if [ -f "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chmod "$RES_PERMISSION" "$FILE"
            chown root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/etc/grub.d
        RES_PERMISSION=og-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"
            chmod -R "$RES_PERMISSION" "$FILE"
            chown -R root:root "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------

        FILE=/var/log
        RES_PERMISSION=go-rwx
        if [ -d "$FILE" ]; then
            printf "\nPermission for $FILE"
            printf "\nBefore: $(ls -l $FILE)"

            chown -R root:root "$FILE"
            chmod -R "$RES_PERMISSION" "$FILE"
            printf "After: $(ls -l $FILE)\n"
        fi

        # --------------------------------------------------


    fi
}

touch permission_set_up.log
set_permission | tee -a permission_set_up.log