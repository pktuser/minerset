## minerset

This script addresses two issues: 1) PKT rewards drop to zero, and 2) create optimum mining order for your mining rig. Once you've set it up, it will mine for you.

/path/to/packetcrypt issues:
-try `../packetcrypt`
-try `/packetcrypt_rs/target/release/packetcrypt'


Minerset.sh will set up your mining command to your preferences using the optimal settings for the miner for best PKT rewards. It will automatically reset the miner based on a timer to avoid PKT rewards drop to zero issue.

Pull from github using 'git clone https://github.com/pktuser/minerset' and run using 'bash minerset/minerset.sh'

Best of luck in your mining.




For developers:[^1]

If anyone knows what causes these dropoffs ping me in the discord server @PKTuser.

[^1] Comments about issue: The leading pool will start to drop off down to 0% goodrates and quickly drag the remaining pools down with it. I have not been able to determine the cause, but I know that resetting the miner solves the problems.

Any code suggestions ping me on the pkt discord server @pktuser
