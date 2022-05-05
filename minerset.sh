#!/bin/bash
clear
# a e s t h e t i c s 
RED="\033[32m"
GREY="\033[90m"
CF="\033[0m"

function configure() {
  printf "\n\n${RED}Leave blank for default values\n"
  printf "DEFAULTS: $CF${GREY}test address, ../packetcrypt, all threads, 4096 diff, no experimental pools, run silent, 60m reset.$CF\n\n"

  read -p "Wallet address (leave blank for default/testing): " addr;
  read -p "Type your /path/to/packetcrypt eg ../packetcrypt: " path
  read -p "Number of threads (leave blank or enter 0 for all threads): " thread
  read -p "Set difficulty, this will determine pool order. 1=2048, 2=4096, 3=8192: " diff
  read -p "Include experimental pools (yes if you have bandwidth). 1=yes, 2=no: " exp
  read -p "Set verbosity 1=show errors, 2=hide errors: " verb
  read -p "Reset timer for miner (integer minutes): " t

  if [ -z $addr ]; then addr="pkt1qxrdhkc8ayyjtla97wmudpgvpz3w0y0tfa7lhfu"; fi
  if [ -z $path ]; then path="../packetcrypt"; fi

  while [ ! -f "$path" ]
  do
    clear
    printf "$RED/path/to/packetcrypt as entered is not valid\n"
    printf "Path stored as: $path\n"
    printf "try: $HOME/packetcrypt$CF\n"
    read -p "Please re-enter path: " path
  done

  if [ -z $thread ]; then thread=0; fi
  if [ -z $diff ]; then diff=2; fi
  if [ -z $exp ]; then exp=2;  fi
  if [ -z $verb ]; then verb=2; fi
  if [ -z $t ]; then t=60; fi
  timer=$t"m"

  if [ $thread -eq 0 ]
  then threads=""
  else threads="-t "$thread
  fi

  if [ $exp -eq 1 ]
  then 
    xp=" https://pool.pkthash.com/ http://p.master.pktdigger.com/"
    xl="-pkthash-pktdigger"
  else
    xp=""
    xl=""
  fi

  if  [ $diff -eq 1 ]
  then
    poollist="https://stratum.zetahash.com/ http://pool.pktpool.io/ http://pool.pkteer.com/ http://pool.pkt.world/$xp"
    p="(zeta-pktpool-pkteer-pktworld$xl)"
    d="(2048)"
  elif [ $diff -eq 3 ]
  then
  poollist="http://pool.pktpool.io/diff/8192 http://pool.pkt.world/ http://pool.pkteer.com/$xp"
  p="(pkpool-pktworld-pkteer$xl)"
  d="(8192)"
  else
    poollist="http://pool.pkt.world/master/4096 http://pool.pktpool.io/ http://pool.pkteer.com/$xp"
    p="(pktworld-pktpool-pkteer$xl)"
    d="(4096)"
  fi

  if [ $verb -eq 2 ]
  then
  verbosity=("2>&1 | grep rs:525")
  v="silent"
  else
  verbosity=""
  v="verbose"
  fi

  save_configuration;
}

function save_configuration() {
  for pool in $poollist
  do
      pools+='"'${pool}'",'
  done
  # Trim last ","
  pools=${pools%?}

  echo '{
          "payment_addr":"'$addr'",
          "threads":'$thread',
          "pools":['$pools'],
          "verbosity":'$verb',
          "timer":"'$timer'",
          "diff":'$diff',
          "path":"'$path'"
        }' > config.json
}

function load_configuration() {
  json_config=$(<./config.json)
  addr=$(echo $json_config | grep -o '"payment_addr":"[^"]*' | grep -o '[^"]*$')
  threads="-t "$(echo $json_config | grep -o '"threads":[^"]*' | grep -o '[0-9]')
  diff=$(echo $json_config | grep -o '"diff":[^"]*' | grep -o '[0-9]')
  verb=$(echo $json_config | grep -o '"verbosity":[^"]*' | grep -o '[0-9]')
  path=$(echo $json_config | grep -o '"path":"[^"]*' | grep -o '[^"]*$')
  timer=$(echo $json_config | grep -o '"timer":"[^"]*' | grep -o '[^"]*$')
  poollist=$(echo $json_config | grep -o \"pools\":\[[\"a-z0-9:\/.,\"]* | grep -o [\"a-z0-9:\/.,\"]*$ | tr -d '"' | tr ',' ' ')
}

function print_configuration() {
  printf "\n================ Configuration ================"
  printf "\n      Pay Addrress: ${addr}"
  printf "\n           Pool(s): ${poollist}"
  printf "\n           Threads: ${threads}"
  printf "\n  Packetcrypt Path: ${path}"
  printf "\n     Reset Timeout: ${timer%?} minutes"
  printf "\n===============================================\n"
}

FILE=./config.json
if test -f "$FILE"; then
    printf "\n\nYou have a saved configuration.\n"
    read -p "Would you like to load it? (yes/no) " load_config

    case $load_config in 
      yes ) load_configuration;;
      no ) configure;;
      * ) echo Invalid response;
        exit 1;;
    esac
else
  configure
fi

mine="timeout $timer $path ann -c ./config.json "
clear
echo "VARIABLES ARE NOW ALL SET"

printf "\n"
print_configuration
printf "\n"
read -p "If above configuration looks correct press Enter to mine or Ctrl-C to escape."

while :
 do
  timestamp=$(date +"|----> current time is "%H%M" <----|")
  printf "\n\n\n"
  echo $timestamp
  printf "\n\n\n"
  echo RESET MODE: $t minute reset - POOLS: $p - DIFFICULTY: $d - ERROR MODE: $v
  echo running miner now . . .

  eval $mine

  printf "\n\n\n"
  echo $t minutes passed, resetting miner . . .

done
