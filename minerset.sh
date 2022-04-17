#!/bin/bash

echo -n "Please enter your wallet address: "
read addr

echo -n "Number of threads (0 for all threads): "
read thread

echo -n "Please enter difficulty, this will determine pool order. 1=2048, 2=4096: "
read diff

echo -n "Set verbosity 1=show errors 2=no errors: "
read verb
##delete line below when fixing verbosity " " issue
#verbosity=""
#v="not set"

echo -n "How often to reset miner (in integer minutes)? "
read t
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

#command=$timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
#mine=$timer ~/packetcrypt ann -p $addr $poollist "${verbosity[@]}" $thread

#echo $command
#echo $mine

#echo $timer ~/packetcrypt ann -p $addr $poollist "${verbosity[@]}" $thread
#echo "press enter when ready"
#read ready

while :
 do
  timestamp=$(date +"|----> current time is "%H%M" <----|")
  printf "\n\n\n"
  echo $timestamp
  printf "\n\n\n"
  echo RESET MODE: $t minute reset - POOLS: $p - DIFFICULTY: $d - ERROR MODE: $v
  echo running miner now . . .

  timeout $timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
  #echo $timer ~/packetcrypt ann -p $addr $poollist $verbosity $thread
  #sleep $t 

  printf "\n\n\n"
  echo $t minutes passed, resetting miner . . .

done
