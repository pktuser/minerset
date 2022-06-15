#!/bin/bash

# build pool list from menu
# user selects pool they want
# programs puts them in order and diff and verb

############### STILL NEEDS THE FOLLOWING: ##############################################
# SET ADDRESS
# 
# 
# SET MINE COMMAND (hypothetically this is all that needs to be passed over)
#########################################################################################

###################set terminal size and use
#resize -s 30 150
#stty rows 30
#stty cols 150
###################

# a e s t h e t i c s 
RED='\033[31m'
GREEN='\033[32m'
NF='\033[0m' # No Format
CF='\033[0m' # compatibility
UNDERLINE='\033[4m'
GREY='\033[90m'

declare -a selectArray
DEFAULT_IFS=$' \t\n'

# define setpoollist() function
unset poollist
setpoollist() {
    if [[ "$z" == "y" ]]; then zp="https://stratum.zetahash.com/"; zz="zeta"; fi
    if [[ "$w" == "y" ]]; then wp="http://pool.pkt.world/"; ww="world"; fi
    if [[ "$p" == "y" ]]; then pp="http://pool.pktpool.io/"; pppp="pool"; fi
    if [[ "$r" == "y" ]]; then rp="http://pool.pkteer.com/"; rr="teer"; fi
    if [[ "$x" == "y" ]]; then xp=""; xx="currently no experimental pools"; fi
    
    ## issue here because zeta is not currently 1024 not 2048
    ## if [[ $diff -eq 2048 ]]; then wm="master/2048"; wp="${wp}${wm}"; poollist="$wp $zp $pp $rp $wp $xp"; difflist="$ww $zz $pppp $rr $ww $xx"; fi
    ## issue here if $wp is not selected, "master/4096" still shows up in poollist. might need a more complex if / then statement to capture
    ## if [[ $diff -eq 4096 ]]; then wm="master/4096"; wp="${wp}${wm}"; poollist="$wp $zp $pp $rp $xp"; difflist="$ww $zz $pppp $rr $xx"; fi
    ## same issue as above except if $pp not selected, "diff/8192" still shows up.
    ## if [[ $diff -eq 8192 ]]; then pm="diff/8192"; pp="${pp}${pm}"; poollist="$pp $wp $rp $xp"; difflist="$pppp $ww $rr $xx"; fi
    ## lines above are preserved for future more complex if/then

    if [[ $diff -eq 2048 ]]; then poollist="http://pool.pkt.world/master/2048 $zp $pp $rp $xp"; fi
    if [[ $diff -eq 4096 ]]; then poollist="http://pool.pkt.world/master/4096 $zp $pp $rp $xp"; fi
    if [[ $diff -eq 8192 ]]; then poollist="http://pool.pktpool.io/diff/8192  $wp $zp $rp $xp"; fi

    difflist="$ww $zz $pppp $rr $xx"

    # catch error - no input select
    if [[ -z $poollist ]]; then poollist="http://pool.pkt.world/ http://pool.pktpool.io/"; difflist="default selected: $ww $pppp"; fi
}


checkProfile() {
    clear
    PS3="Your selection: "
    printf "${RED}Load previous settings? ${NF}\n"
    options=("Yes, load previous settings" "No, start from scratch")
    select opt in "${options[@]}"
    do
        if [[ $REPLY -eq 1 ]]; then loadProfile; break; fi
        if [[ $REPLY -eq 2 ]]; then createProfile; break; fi
        break
    done
}

loadProfile() {

    mapfile -t selectArray < selectset.log

    # issue here, all the variables should simple be selectArray[] throughout rather than defining twice
    wallAddr="${selectArray[0]}"
    diff="${selectArray[1]}"
    poollist="${selectArray[2]}"
    verb="${selectArray[3]}"
    thread="${selectArray[4]}"
    timer="${selectArray[5]}"
    path="${selectArray[6]}"

    if [[ -z $thread ]]
        then threadout="${GREEN}CPU threads:${NF} (all threads)"
        else threadout="${GREEN}CPU threads:${NF} $thread"
    fi



    printf "${UNDERLINE}${RED}Profile loaded as follows: ${NF}\n"
    printf "${GREEN}Wallet addr:${NF} ${selectArray[0]}\n"
    printf "${GREEN}Difficulty:${NF}  ${selectArray[1]}\n"
    printf "${GREEN}Pool list:${NF}   ${selectArray[2]}\n"
    printf "${GREEN}Verbosity:${NF}   ${selectArray[3]}\n"
    printf "${GREEN}CPU threads:${NF} ${selectArray[4]}\n"
    printf "${GREEN}Timer:${NF}       ${selectArray[5]}\n"
    printf "${GREEN}Packetcrypt path:${NF} ${selectArray[6]}\n\n"



    read -p "enter" entr
    review

}

createProfile() {

    # menu 0 - wallet address
    read -p $'\033[31mEnter your wallet address for mining (leave blank to donate some mining time): \033[0m' wallAddr
    if [[ -z wallAddr ]]; then wallAddr=pkt1qxrdhkc8ayyjtla97wmudpgvpz3w0y0tfa7lhfu; fi
    
    # menu 1 - select diff
    clear
    PS3="Your selection: "
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${RED}Select difficulty to mine: ${NF}\n"
    select opt in 2048 4096 8192
    do
        diff=$opt
        break
    done


    # menu 2 - build pools
    clear
    title="Select pools to mine, 6 to confirm: "
    PS3="Your selection: "
    COLUMNS=0
    options=("Pktworld" "Pktpool" "Pkteer" "Zeta (currently unstable)" "Experimental (currently none)" "Confirm")
    while true; do
        clear
        printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
        printf "${GREEN}Difficulty:${NF}  $diff\n\n"
        printf "${RED}$title${NF}\n"
        options=( "${options[@]/$delete}" )
        select opt in "${options[@]}"
        do
            case $opt in
                "${options[0]}")
                    title="Pktworld added to list"
                    w="y"
                    delete="Pktworld"
                    break
                    ;;
                "${options[1]}")
                    title="Pktpool added to list"
                    p="y"
                    delete="Pktpool"
                    break
                    ;;
                "${options[2]}")
                    title="Pkteer added to list"
                    r="y"
                    delete="Pkteer"
                    break
                    ;;
                "${options[3]}")
                    title="Zeta added to list"
                    z="y"
                    delete="Zeta (currently unstable)"
                    break
                    ;;
                "${options[4]}")
                    title="Experimental pools added to list"
                    x="y"
                    delete="Experimental (currently none)"
                    break
                    ;;
                "${options[5]}")
                    setpoollist
                    break 2
                    ;;
                *) echo "option $REPLY invalid";;
            esac
        done
    done

    # menu 3 - select verbosity
    clear
    unset verb
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${GREEN}Difficulty:${NF}  $diff\n"
    printf "${GREEN}Pool list:${NF}   $poollist\n\n"
    PS3="Your selection: "
    printf "${RED}How should your miner display progress: ${NF}\n"
    options=("Show all messages" "Show only uploads" "Show nothing")
    select opt in "${options[@]}"
    do
        if [[ $REPLY -eq 1 ]]; then verb=""; v="show all messages"; fi
        if [[ $REPLY -eq 2 ]]; then verb="2>&1 | grep 'Ke/s'"; v="Show only uploads"; fi
        if [[ $REPLY -eq 3 ]]; then verb="2>&1 | grep silent"; v="Show nothing"; fi
        break
    done

    # menu 4 - set threads
    clear
    unset timer
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${GREEN}Difficulty:${NF}  $diff\n"
    printf "${GREEN}Pool list:${NF}   $poollist\n"
    printf "${GREEN}Verbosity:${NF}   $verb\n\n"
    read -p $'\033[31mNumber of CPU threads (leave blank for all threads): \033[0m' thread
    if [[ -z $thread ]]
    then thread=""; threadout="${GREEN}CPU threads:${NF} (all threads)"
    else thread="-t "$thread; threadout="${GREEN}CPU threads:${NF} $thread"
    fi

    # menu 5 - set reset timer
    clear
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${GREEN}Difficulty:${NF}  $diff\n"
    printf "${GREEN}Pool list: ${NF}  $poollist\n"
    printf "${GREEN}Verbosity: ${NF}  $verb\n"
    printf "$threadout\n\n"
    read -p $'\033[31mHow often should your miner reset (60 minutes suggested):  \033[0m' t
    if [[ -z $t ]]; then t=60; fi
    timer=$t"m"

    # menu 6 - path to packetcrypt FFS all of this is already set in the wallet side. need to think of overall organization. fuck early releasing this to public
    # also check into integrating with Kuzu DR web updates
    clear
    printf "${UNDERLINE}${RED}Mining Commands${NF}\n"
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${GREEN}Difficulty:${NF}  $diff\n"
    printf "${GREEN}Pool list:${NF}   $poollist\n"
    printf "${GREEN}Verbosity:${NF}   $verb\n"
    printf "$threadout\n"
    printf "${GREEN}Timer:${NF}       $timer\n"
    echo
    read -p $'\033[31mType your /path/to/packetcrypt, leave blank for ../packetcrypt: \033[0m' path
    if [ -z $path ]; then path="../packetcrypt"; fi

    while [ ! -f "$path" ]
    do
        clear
        printf "$RED/path/to/packetcrypt as entered is not valid\n"
        printf "Path stored as: $path\n"
        printf "try: $HOME/packetcrypt$CF\n"
        read -p "Please re-enter path: " path
    done

    saveProfile

}



###########################################################################################################################
############################ THIS WILL ALL BE ADDED TO selectArray[] TO BE STORED AND ENCRYPTED ##########################
###########################################################################################################################

saveProfile() {

    printf "$wallAddr\n$diff\n$poollist\n$verb\n$thread\n$timer\n$path\n" > selectset.log
    review

}


review() {

    clear
    printf "${UNDERLINE}${RED}Mining Commands${NF}\n"
    printf "${GREEN}Wallet addr:${NF} $wallAddr\n"
    printf "${GREEN}Difficulty:${NF}  $diff\n"
    printf "${GREEN}Pool list:${NF}   $poollist\n"
    printf "${GREEN}Verbosity:${NF}   $verb\n"
    printf "$threadout\n"
    printf "${GREEN}Timer:${NF}       $timer\n"
    printf "${GREEN}Packetcrypt path:${NF} $path\n"

    echo
    mine="timeout $timer ../packetcrypt ann -p $wallAddr $poollist $thread $verb"
    echo $mine
    echo
    read -p "review command above, enter to run - ctrl-c to quit" entr

    #export variables to tmp file


    #sleep 2s
    echo "select.sh is now finished"
    mine

}


### mine
mine() {
while :
 do
  timestamp=$(date +"|----> current time is "%H%M" <----|")
  printf "\n\n\n"
  echo $timestamp
  printf "\n\n\n"
  echo RESET MODE: $t minute reset - POOLS:  $difflist - DIFFICULTY: $diff - ERROR MODE: $verb
  echo running miner now . . .

    eval $mine
 ##  eval timeout $timer ../packetcrypt ann -p pkt1q9dczv9ne8mfg98aya90kepflk2j2whhfqqn0mk $poollist$verb

  printf "\n\n\n"
  echo $timer minutes passed, resetting miner . . .

done
}

# onRun
if [ -f selectset.log ]; then checkProfile; else createProfile; fi

