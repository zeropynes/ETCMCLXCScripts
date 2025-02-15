#!/bin/sh

echo 'Updating Linux...'
apt update 
apt dist-upgrade -y 
clear

echo -e "\033[1;31m" # Red text color
cat << "EOF"
    ____________________  _________             
   / ____/_  __/ ____/  |/  / ____/             
  / __/   / / / /   / /|_/ / /                  
 / /___  / / / /___/ /  / / /___                
/_____/ /_/ _\____/_/  /_/\____/  __            
   / /  | |/ / ____/  / ___/___  / /___  ______ 
  / /   |   / /       \__ \/ _ \/ __/ / / / __ \
 / /___/   / /___    ___/ /  __/ /_/ /_/ / /_/ /
/_____/_/|_\____/   /____/\___/\__/\__,_/ .___/ 
                                       /_/      
EOF
echo -e "\033[1;36m" # Cyan text color
cat << "EOF"
      CREATED BY dark_knight

EOF
echo -e "\033[0m" # Reset text color
echo "PS: If you would like to donate to support ongoing development, send ETC/ETCPOW to our wallet:"
echo "0xA24BC49b794b3bEc609aD72cD7017FFB6e784E2C"
sleep 30

