#!/bin/bash


echo -e "
   ____                             \033[01;31m _____\033[0m                                    
  / ___|_ __ ___  _   _ _ __   ___  \033[01;31m| ____|__ _ ___ _   _ \033[0m ___ ___  _ __ ___  
 | |  _| '__/ _ \| | | | '_ \ / _ \ \033[01;31m|  _| / _  / __| | | |\033[0m/ __/ _ \| '_ ' _ \ 
 | |_| | | | (_) | |_| | |_) |  __/ \033[01;31m| |__| (_| \__ \ |_| |\033[0m (_| (_) | | | | | |
  \____|_|  \___/ \__,_| .__/ \___| \033[01;31m|_____\__,_|___/\__, |\033[0m\___\___/|_| |_| |_|
                       |_|          \033[01;31m                |___/ \033[0m                   

"


[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

printf "Bienvenue sur %s (%s).\n" "$DISTRIB_DESCRIPTION" "$(uname -r)"
printf "\n"

date=`date`
load=`cat /proc/loadavg | awk '{print $1}'`
slash_usage=`df -h | grep '/$' | awk '/\// {print $(5)}' | head -n 1`
slash_dispo=`df -h | grep '/$' | awk '/\// {print $(4)}' | head -n 1`
memory_usage=`free -m | awk '/Mem/ { printf("%3.1f%%", $3/$2*100) }'`
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", $3/$2*100) }'`
swap_used=`free -m | awk '/Swap/ { printf($3) }'`
users=`users | wc -w`

echo "Date du système : $date"
printf "Load : %s \t\t RAM utilisée : %s \n" $load $memory_usage
printf "Usage du disque : %s \t Reste : %s \n" $slash_usage $slash_dispo
printf "Usage de /var : %s \t Reste : %s \n" $var_usage $var_dispo


printf "Usage du Swap : %s \n" $swap_usage
printf "Utilisateurs connectés: %s \n" $users

/usr/lib/update-notifier/apt-check --human-readable
