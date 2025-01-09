#!/bin/bash
#
# Author: Manohar Barma
# Description: User creation automation script
# Version: 1.0
# Date: 09-01-2025
# Contact: manoharbarma07@gmail.com
#
#
if [ $# -gt 0 ]; then
    echo "Initiating user creation"
    for user in $@; do
        if [[ $user =~ ^[a-z]{4}[0-9]{2}$ ]]; then
            existing_user=$(awk -F":" -v user="$user" '$1 == user { print $1 }' /etc/passwd)
            if [ -n "$existing_user" ]; then
                echo "User $user already exists"
            else
                echo "Creating user $user"
                sudo useradd $user --shell /bin/bash
                password="${user}!$(shuf -i 10000-99999 -n 1)"
                echo "$user:$password" | sudo chpasswd
                echo "User \"$user\" created with password \"$password\""
                sudo passwd -e $user > /dev/null
                echo "Change the password after first login."
            fi
        else
            echo -e "Invalid username format for $user.\n            It should be 4 characters followed by 2 digits."
            continue
        fi
    done
else
    echo "Pass the valid parameters for user creation"
fi