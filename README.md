# minerset

Early in 2022 I found that after letting the miner run long periods of time I would see my rewards suddnely drop to 0. I check the miner and find CPU at 100% but goodrates at 0%. The quick fix was to simply stop and restart the miner. I set up a simple shell script to automatically restart the miner for me. This eliminated those drop-offs where rewards dropped to 0 while miner kept running.

minerset.sh is a more polished version of this script which allows miner operator to customize the mining command prior to running it so it's a bit more universal and user-friendly. By using this script on all of your miners you can easily ensure that you're using the same settings which has shown to improve results from the blkminers and increase your rewards.

If you used SDN settings to install and compile your miner, this should work without edits. Otherwise the only edit you need to make is path/to/packetcrypt.

Pull from github using 'git clone https://github.com/pktuser/minerset' and run using 'bash minerset/minerset.sh'

Best of luck in your mining.


For developers:
If anyone knows what causes these dropoffs ping me in the discord server @PKTuser.
Comments about issue:It seems like the leading pool will start to drop off down to 0% goodrates and quickly drag the remaining pools down with it. I have not been able to determine the cause, but I know that resetting the miner solves the problems.
Any code suggestions ping me on the pkt discord server @pktuser
