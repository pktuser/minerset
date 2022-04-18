#!/bin/bash

read -p "Please enter your wallet address: " addr
read -p "Number of threads (0 for all threads): " thread
read -p "Please enter difficulty, this will determine pool order. 1=2048, 2=4096: " diff
read -p "Set verbosity 1=show errors 2=no errors: " verb
##delete line below when fixing verbosity " " issue
#verbosity=""
#v="not set"

read -p "How often to reset miner (in integer minutes)? " t
timer=$t"m"

if [ $thread -eq 0 ]
 then thread=""
 else thread="-t "$thread
fi

if  [ $diff -eq 1 ]
 then
  poollist="https://stratum.zetahash.com/ http://pool.pktpool.io/ http://pool.pkteer.com/ http://pool.pkt.world/"
  p="zeta - pktpool - pkteer - pktworld"
  d=2048
 else
  poollist="http://pool.pkt.world/ http://pool.pktpool.io/ http://pool.pkteer.com/"
  p="pktworld - pktpool - pkteer"
  d=4096
fi

if [ $verb -eq 2 ]
 then
 verbosity=('2>&1 | grep --color=never -o "annmine.rs.*Ke.*"')
 v="silent"
 else
 verbosity=""
 v="verbose"
fi

##testing output, delete all this later
#echo $verbosity
#echo "${verbosity[@]}"

command=$timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
mine=$timer ~/packetcrypt ann -p $addr $poollist "${verbosity[@]}" $thread

echo "This text calls verbosity as a string: "$command
echo "This text verbosity as an array: "$mine

read -p "Press Enter when ready."

while :
 do
  timestamp=$(date +"|----> current time is "%H%M" <----|")
  printf "\n\n\n"
  echo $timestamp
  printf "\n\n\n"
  echo RESET MODE: $t minute reset - POOLS: $p - DIFFICULTY: $d - ERROR MODE: $v
  echo running miner now . . .

#  timeout $timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
#  echo $timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
  echo "This text calls verbosity as a string: "$command
  echo "This text verbosity as an array: "$mine
  sleep $t 

  printf "\n\n\n"
  echo $t minutes passed, resetting miner . . .

done
