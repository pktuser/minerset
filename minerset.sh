#!/bin/bash

echo "Leave blank for default values - test address, all threads, 4096 diff, run silent, 60m timer."
read -p "Please enter your wallet address (leave blank for default/testing): " addr
read -p "Number of threads (0 for all threads): " thread
read -p "Please enter difficulty, this will determine pool order. 1=2048, 2=4096: " diff
read -p "Set verbosity 1=show errors 2=hide errors: " verb
read -p "How often to reset miner (in integer minutes)? " t
timer=$t"m"

if [ -z $addr ]; then addr="pkt1qxrdhkc8ayyjtla97wmudpgvpz3w0y0tfa7lhfu"; fi
if [ -z $thread ]; then thread=0; fi
if [ -z $diff ]; then diff=2; fi
if [ -z $verb ]; then verb=2; fi
if [ -z $t ]; then t=60; fi

echo "VARIABLES ARE:"
printf "\n"
echo "addr " $addr 
echo "thread " $thread 
echo "diff " $diff 
echo "verb " $verb 
echo "t " $t
printf "\n"

if [ $thread -eq 0 ]
 then thread=""
 else thread="-t "$thread
fi

if  [ $diff -eq 1 ]
 then
  poollist="https://stratum.zetahash.com/ http://pool.pktpool.io/ http://pool.pkteer.com/ http://pool.pkt.world/"
  p="(zeta-pktpool-pkteer-pktworld)"
  d="(2048)"
 else
  poollist="http://pool.pkt.world/ http://pool.pktpool.io/ http://pool.pkteer.com/"
  p="(pktworld-pktpool-pkteer)"
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

mine="timeout $timer ~/packetcrypt ann -p $addr $poollist $thread "${verbosity[@]}" "
echo "VARIABLES ARE NOW ALL SET"
printf "\n"
echo "addr " $addr 
echo "thread " $thread 
echo "diff " $diff 
echo "verb " $verb 
echo "t " $t
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
