#!/bin/sh

clear
echo 'Checking Scripts. Please wait...'



###nodeboost.sh

if [ -e /root/etcmc/nodeboost/nodeboost.sh ]
then
    rm /root/etcmc/nodeboost/nodeboost.sh
fi

if [ -e /root/etcmc/nodeboost/bootstrap.txt ]
then
    rm /root/etcmc/nodeboost/bootstrap.txt
fi

if [ -e /root/etcmc/nodeboost/my_nodes.txt ]
then
    rm /root/etcmc/nodeboost/my_nodes.txt
fi

if [ -d nodeboost ]
then
    rm -rf nodeboost
fi

clear
echo "Update Complete!"
echo "\n"
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