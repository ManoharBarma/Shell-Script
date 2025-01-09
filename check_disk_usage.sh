#!/bin/bash
#
# Author: Manohar Barma
# Description: Check disk usage script
# Version: 1.0
# Date: 09-01-2025
# Contact: manoharbarma07@gmail.com
#
#
check_disk_usage() {
    if [ $# -eq 0 ]; then
        echo "Error: Please provide a directory path to check. ex: /home"
        exit 1
    else
        dir_path=$@
        usage_limit=80
        for dir in $dir_path; do
            disk_usage=$(df -h "$dir" | awk 'NR==2 {gsub("%",""); print $5}')
            if [ -z "$disk_usage" ]; then
                echo "Error: Invalid directory path."
            elif [ "$disk_usage" -gt "$usage_limit" ]; then
                echo "$dir exceeded limit with $disk_usage% usage"
            else
                echo "$dir within limits with $disk_usage% usage"
            fi
        done
    fi
}

# calling the function
check_disk_usage "$@"