#!/bin/bash

# List all ETCMC Node LXC ID
containers=$(pct list | grep ETCMC | awk 'NR>0 {print $1}')

# Update auto_claim.json File
AUTOCLAIM_JSON='{"auto_claim": "no"}'

# Start Update
echo "Starting to update ETCMC LXC Containers"
for container in $containers; do
    echo "Updating ETCMC LXC: $container"
    pct exec $container -- bash -c "cd etcmc ; echo '$AUTOCLAIM_JSON' > auto_claim.json" || echo "Error updating auto_claim.json file"
done

echo -e "\033[1;36m" # Cyan text color
cat << "EOF"
   ____                _           _   ____              
  / ___|_ __ ___  __ _| |_ ___  __| | | __ ) _   _       
 | |   | '__/ _ \/ _` | __/ _ \/ _` | |  _ \| | | |      
 | |___| | |  __/ (_| | ||  __/ (_| | | |_) | |_| |      
  \____|_|  \___|\__,_|\__\___|\__,_| |____/ \__, |      
                                             |___/       
      _            _        _          _       _     _   
   __| | __ _ _ __| | __   | | ___ __ (_) __ _| |__ | |_ 
  / _` |/ _` | '__| |/ /   | |/ / '_ \| |/ _` | '_ \| __|
 | (_| | (_| | |  |   <    |   <| | | | | (_| | | | | |_ 
  \__,_|\__,_|_|  |_|\_\___|_|\_\_| |_|_|\__, |_| |_|\__|
                      |_____|            |___/           
EOF

echo "\n"
echo -e "\033[1;33m" # Cyan text color
echo "Please Donate ETC/ETCPOW to our wallet:"
echo "0xA24BC49b794b3bEc609aD72cD7017FFB6e784E2C"
echo -e "\033[0m" # Reset text color