#!/bin/bash
#
#Author: Manohar_Barma
#description: User creation automation
#
#
 if [ $# -gt 0 ]; then
 echo " Creation started "
 for user in $@ ;
 do
	 existing_user=$(cat /etc/passwd | grep $user | awk -F":" '{ print $1 }')
	 echo $existing_user
	 

done
else 
 echo " pass the valid parameters for user creation "	
 fi
