## minerset

This script addresses two issues: 1) PKT rewards drop to zero, and 2) create optimum mining order for your mining rig.

Minerset.sh will set up your mining command to your preferences using the optimal settings for the miner for best PKT rewards. It will automatically reset the miner based on a timer to avoid PKT rewards drop to zero issue.

If you used SDN settings to install and compile your miner, this should work without edits. Otherwise edit line 48 ~/packetcrypt - adjust the correct path/to/packetcrypt. Depending on your install this could look like ./target/release/packetcrypt or ~/packet/packetcrypt_rs/target/release/packetcrypt -- check what works for you.

Pull from github using 'git clone https://github.com/pktuser/minerset' and run using 'bash minerset/minerset.sh'

Best of luck in your mining.


For developers:
If anyone knows what causes these dropoffs ping me in the discord server @PKTuser.
Comments about issue:It seems like the leading pool will start to drop off down to 0% goodrates and quickly drag the remaining pools down with it. I have not been able to determine the cause, but I know that resetting the miner solves the problems.
Any code suggestions ping me on the pkt discord server @pktuser
