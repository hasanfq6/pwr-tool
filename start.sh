#!/usr/bin/env bash

now="$(date)"
printf "%s\n"
now="$(date +'%d/%m/%Y')"

m="$(date)"

m="$(date +'%H:%M:%S')"

null="~> /dev/null 2>&1"
g="\033[1;32m"
r="\033[1;31m"
b="\033[1;34m"
i="\033[33m"
L="\033[36m"
P="\033[35m"
G="\033[1;96m"
W="\033[30m"
M="\e[1;45m"
C="\e[1;46m"
B="\e[1;40m"
w="\033[0m"
Z="\033[4;31m"
K="\033[0;100m"
D="\033[4;31m"


# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

echo -e $L"Select one option using up/down keys and enter to confirm:"$w
echo

function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}
## banner
banner(){
echo -e $P" ____                   _____           _ "$w
echo -e $P"|  _ \__      ___ __   |_   _|__   ___ | |"$w
echo -e $P"| |_) \ \ /\ / / '__|____| |/ _ \ / _ \| |"$w
echo -e $P"|  __/ \ V  V /| | |_____| | (_) | (_) | |"$w
echo -e $P"|_|     \_/\_/ |_|       |_|\___/ \___/|_|"$w
echo ""
echo -e $K"Tools contain most powerfull Tools inside "$w$G
}
banner
play-audio /data/data/com.termux/files/home/.misc/Pwr.wav &> /dev/null;
options=("[1] nmap [50mp]" "[2] hydra [69mp]" "[3] Metasploit [200mp]" "[4] Sqlmap [80mp]" "[5] F-society [80-100mp]" "[6] TermShark [wire shark]" "[7] slowloris [20mp]" "[8] Social Engineering Toolkit [100-200]" "[9] Nikto [??]" "[10] Tool-X" "[11] crunch [10mp]" "[12] guide" "[13] Info about Tools" "${array[@]}")
case `select_opt "${options[@]}"` in
    0) echo -e $g"[-] inatalling nmap"$w
       pkg install nmap -y &> /dev/null;
       echo -e $g"[+] installed..."$w
       ;;
    1) echo -e $i"[+] installing hydra"$w
       apt install -y python php curl wget git nano &> /dev/null;
       cd $HOME
       git clone https://github.com/vanhauser-thc/thc-hydra &> /dev/null;
       cp thc-hydra $HOME
       cd $HOME/thc-hydra 
       ./configure &> /dev/null;
       make &> /dev/null;
       make &> /dev/null;
       install &> /dev/null;
       echo -e $g"hydra has been installed succesfully"$w
       echo -e $K"now start hydra by"$g"./hydra -h"$w
       ;;
    2)
       echo -e $i"[-] Installing metasploit without any error"$w$r"["$g"200mp"$r"]"$w
       source <(curl -fsSl https://raw.githubusercontent.com/efxtv/Metasploit-in-termux/main/metasploit-6-termux.sh)
       echo -e $g"[+] installed..."$w
       ;;
    3)
       echo -e $i"[+] installing Sqlmap"$w
       git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev &> /dev/null;
       echo -e $g"[+] installed..."$w
       ;;
    4)
       echo -e $i"[-] installing F-society"$w
       pkg install git -y &> /dev/null;
       pkg install python2 -y &> /dev/null;
       git clone https://github.com/Manisso/fsociety.git &> /dev/null;
       echo -e $g"[+] installed..."$w 
       ;;
     5)
       echo -e $i"[+] installing TermShark"$w
       pkg install wget -y &> /dev/null;
       GO111MODULE=on 
       git clone https://github.com/gcla/termshark &> /dev/null;
       cp termshark $HOME 
       echo -e $g"[+] installed..."$w
       ;;
     6)
        echo -e $i"[-] installing Slowloris"$w
        pkg install python -y &> /dev/null;
        pip install slowloris -y &> /dev/null;
        echo -e $g"[+] installed..."$w
        ;;
     7)
        echo -e $i" [+] installing Social Engineering Toolkit"$w
        apt install curl -y &> /dev/null;
        curl -LO https://raw.githubusercontent.com/Hax4us/setoolkit/master/setoolkit.sh &> /dev/null;
        sh setoolkit.sh &> /dev/null;
        cp setoolkit $HOME 
        echo -e $g"[+] installed..."$w
        ;;
     8)
        echo -e $i"[-] installing Nikto"$w
        pkg install perl -y &> /dev/null;
        git clone https://github.com/sullo/nikto.git &> /dev/null;
        cp nikto $HOME
        echo -e $g"[+] installed..."$w
        ;;
     9)
        echo -e $i"[+] installing Tool-x"
        git clone https://github.com/Rajkumrdusad/Tool-X.git &> /dev/null;
        cp Tool-X $HOME
        echo -e $g"[+] installed..."$w
        ;;
     10)
        echo -e $i"[-] installing crunch"$w
        pkg install crunch -y &> /dev/null;
        ;;
     11)
        echo -e $i"[×] inatalling requierd pkgs"$w
        pkg install pv -y &> /dev/null;
        pkg install x11-repo -y &> /dev/null;
        pkg install play-audio -y &> /dev/null;
        echo ""
        echo -e $K"[-] please read the instructions carefully"$w | pv -qL 14
        play-audio /data/data/com.termux/files/home/.misc/misc.mp3 &> /dev/null;
        echo ""
        echo -e $K"- Installed tools will be stored in the Home directory"$w | pv -qL 17
        echo ""
        echo -e $K"- each tools will take upto"$g"10-15"$w$K"min please be calm"$w | pv -qL 17
        echo ""
        echo -e $K"- All tools will installed without error"$w | pv -qL 17
        echo ""
        echo -e $K"- Thank you for using this tools"$w | pv -qL 17
        ;;
     12)
        echo -e $K"All Tool Information"$w
        echo ""
        play-audio /data/data/com.termux/files/home/.misc/misc1.mp3
        echo -e $G"[1] Nmap  == "$g"Tool for scaning the network in termux and linux"$w
        echo ""
        echo -e $G"[2] Hydra == "$g"Tool for brute fore attack by simple way"$w | pv -qL 15
        echo ""
        echo -e $G"[3] Metasplaoit == "$g"It is not a Tool It is Framework"$r"["$b"contains more the 2500+ modules"$r"]"$w | pv -qL 18
        echo ""
        echo -e $G"[4] Sql map == "$g"Tool for hacking website Data base or checking for vulnurabilities"$w | pv -qL 19
        echo ""
        echo -e $G"[5] F-society == "$g"Tool for various type of hacking"$w | pv -qL 15
        echo ""
        echo -e $G"[6] TermShark == "$g"Tool that we can use WireShark in TermShark"$w | pv -qL 17
        echo ""
        echo -e $G"[7] Slowloris == "$g"Tool for perform DOS or DDOS attack on website"$w | pv -qL 17
        echo ""
        echo -e $G"[8] S.E Toolkit == "$g"Tool that have social Engineering Attacks"$w | pv -qL 18
        echo ""
        echo -e $G"[9] Nikto == "$g"Tool that chect Issue in WebApplication and to pawrm"$w | pv -qL 18
        echo ""
        echo -e $G"[10] Tool-X == "$g"Tool That have more than 350+ Tools for e-hacking"$w | pv -qL 18
        echo ""
        echo -e $G"[11] Crunch == "$g"Tool for creating Bulk password list by numbers and All posible letters"$w | pv -qL 20
        echo ""
        ;;

     *) echo "selected ${options[$?]}";;

esac
