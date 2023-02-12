#!/bin/bash

# Author: l3shy
# Date: 2-11-23
# Purpose: Automate the initial process of enumeration to keep things simple and save time.

#Color coding to make it look nice ;)
GLD='\033[0;33m'
GRN='\033[0;32m'
PRP='\033[0;35m'
RED='\033[0;31m'
CL='\033[0m'

echo -e '\n'
nmap_enum() {
    echo -e "${GLD}====================STARTING NMAP SCAN====================${CL}"
    nmap -sC -sV -p- $1 -oA nmap_baseline
    echo -e "${GRN}====================NMAP SCAN COMPLETE====================${CL}\n"
}

gobuster_enum() {
    echo -e "${GLD}====================STARTING GOBUSTER SCAN====================${CL}"
    gobuster dir -t60 -u http://$1 -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt -o gobuster_baseline
    echo -e "${GRN}====================GOBUSTER SCAN COMPLETE====================${CL}\n"
}

nikto_enum() {
    echo -e "${GLD}====================STARTING NIKTO SCAN====================${CL}"
    nikto -h $1
    echo -e "${GRN}====================NIKTO SCAN COMPLETE====================${CL}\n"
}

check_joom() {
response=$(curl -s --head -w %{http_code} http://$1/administrator -o /dev/null)
    echo -e "${GLD}====================CHECKING FOR JOOMLA ADMIN PANEL====================${CL}"
if [ $response != "301" ];
then
    echo -e "This site ${RED}does not${CL} appear to use Joomla\n"
else
    echo -e "This site appears to have an ${PRP}Joomla${CL} admin panel present at https://$1/administrator\n"
fi
}

check_wp() {
    echo -e "${GLD}====================CHECKING FOR WORDPRESS ADMIN PANEL====================${CL}"
response=$(curl -s --head -w %{http_code} http://$1/wp-login.php -o /dev/null)
if [ $response != "301" ];
then
    echo -e "This site ${RED}does not${CL} appear to use WordPress\n"
else
    echo -e "This site appears to have an ${PRP}Word Press${CL} admin panel present at https://$1/administrator\n"
fi
}


nmap_enum $1
gobuster_enum $1
nikto_enum $1
check_joom $1
check_wp $1
