#!/bin/bash
#
#Author: Manohar_Barma
#description: User creation automation
#
#
if [ $# -gt 0 ]; then
    echo " Creation started "
    for user in $@; do
        existing_user=$(grep -w "^$user" /etc/passwd | awk -F":" '{ print $1 }')
        if [ -n "$existing_user" ]; then
            echo "user already exists"
        else
            echo "creating user $user"
            sudo useradd $user --shell /bin/bash
            password="${user}!$(shuf -i 1000-9999 -n 1)"
            echo "$user:$password" | sudo chpasswd
            echo "User $user created with password $password"
        fi
    done
else
    echo " pass the valid parameters for user creation "
fi