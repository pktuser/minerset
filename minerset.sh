#!/bin/bash

printf "\n\n\033[32mLeave blank for default values\033[0m\n"
echo "test address, ~/packetcrypt, all threads, 4096 diff, no experimental pools, run silent, 60m reset."
printf "\n"
read -p "Wallet address (leave blank for default/testing): " addr
read -p "Type your ./path/to/packetcrypt eg ~/packetcrypt: " path
read -p "Number of threads (leave blank or enter 0 for all threads): " thread
read -p "Set difficulty, this will determine pool order. 1=2048, 2=4096, 3=8192: " diff
read -p "Include experimental pools (yes if you have bandwidth). 1=yes, 2=no: " ex
read -p "Set verbosity 1=show errors, 2=hide errors: " verb
read -p "Reset timer for miner (integer minutes): " t

if [ -z $addr ]; then addr="pkt1qxrdhkc8ayyjtla97wmudpgvpz3w0y0tfa7lhfu"; fi
if [ -z $path ]; then path="~/packetcrypt"; fi
while [ ! -f "$path" ]
 do
  clear
  printf "\033[31m./path/to/packetcrypt as entered is not valid\033[0m\n\n"
  echo $path
  read -p "Please re-enter path: " path
done



if [ -z $thread ]; then thread=0; fi
if [ -z $diff ]; then diff=2; fi
if [ -z $ex ]; then ex=2;  fi
if [ -z $verb ]; then verb=2; fi
if [ -z $t ]; then t=60; fi
timer=$t"m"

if [ $thread -eq 0 ]
 then thread=""
 else thread="-t "$thread
fi

if [$ex -eq 1 ]
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
 p="(pkpool-pktworld-pkteer-pkthash-pktdigger$xl)"
 d="(8192)"
else
  poollist="http://pool.pkt.world/master/4096 http://pool.pktpool.io/ http://pool.pkteer.com/$xp"
  p="(pktworld-pktpool-pkteer$xl)"
  d="(4096)"
fi

if [ $verb -eq 2 ]
 then
 verbosity=('2>&1 | grep --color=never -o "annmine.rs.*Ke.*"')
 v="silent"
 else
 verbosity=""
 v="verbose"
fi

mine="timeout $timer $path ann -p $addr $poollist $thread "${verbosity[@]}" "
echo "VARIABLES ARE NOW ALL SET"

printf "\n"
echo $mine
printf "\n"
read -p "If above mining command looks correct press Enter to mine or Ctrl-Z to escape."

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
