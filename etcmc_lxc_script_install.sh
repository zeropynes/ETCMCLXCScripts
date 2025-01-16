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

echo 'Initializing ETCMC Linux Installation...'
sleep 5
mkdir -p /root/etcmc
wget https://github.com/Nowalski/ETCMC_Software/releases/download/Setup%2FWindows/ETCMC_Linux.zip -O /root/ETCMC_Linux.zip
clear

echo 'Installing ETCMC Linux...'
sleep 5
apt install unzip python3 python3-pip screen curl jq  -y 
pip install --upgrade pip
unzip /root/ETCMC_Linux.zip -d /root/etcmc
chmod -R 775 /root/etcmc/
cd /root/etcmc
pip install -r requirements.txt
chmod +x Linux.py ETCMC_GETH.py updater.py geth
clear

echo 'Creating ETCMC Linux Scripts...'
sleep 5

cat << EOF > /root/etcmc/start.sh
#!/bin/sh
# Creating etcmc screen session as detached
/usr/bin/screen -dmS etcmc

# Starting etcmc node on port 5000 and exit screen session immediately when stopped
/usr/bin/screen -S etcmc -X stuff "/usr/bin/python3 /root/etcmc/Linux.py start --port 5000\n" 1>/dev/null 2>&1
/usr/bin/screen -S etcmc -X stuff "exit\n" 1>/dev/null 2>&1
EOF
chmod +x /root/etcmc/start.sh

cat << EOF > /root/etcmc/stop.sh
#!/bin/sh
# Stopping etcmc node
/usr/bin/python3 /root/etcmc/Linux.py stop
EOF
chmod +x /root/etcmc/stop.sh

cat << EOF > /root/etcmc/poweroff.sh
#!/bin/sh
# Stopping etcmc node
/root/etcmc/stop.sh

# Powering down machine
/sbin/poweroff
EOF
chmod +x /root/etcmc/poweroff.sh

cat << EOF > /root/etcmc/update.sh
#!/bin/sh
python3 Linux.py stop
python3 Linux.py update
pip3 install -r requirements.txt --break-system-packages --ignore-installed
pip3 install plyer websockets aiohttp --ignore-installed
pip3 install flask --ignore-installed
echo 'ETCMC Updated. Starting ETCMC Node now...'
sleep 5
./start.sh
EOF
chmod +x /root/etcmc/update.sh

cat << EOF > /root/etcmc/config_update.sh
#!/bin/sh
# Stopping etcmc node
/usr/bin/python3 /root/etcmc/Linux.py stop

if [ -e config.toml.old ]
then
    if [ -e config.toml ]
    then
        rm config.toml.old
        mv config.toml config.toml.old
    fi
else
    mv config.toml config.toml.old
fi

wget https://github.com/zeropynes/ETCMCLXCScripts/raw/refs/heads/main/config.toml -O /root/etcmc/config.toml

echo 'ETCMC Config Updated. You can start your ETCMC Node now...'
EOF
chmod +x /root/etcmc/config_update.sh

cat << EOF > /root/etcmc/scripts_update.sh 
#!/bin/sh

clear
wget -O - https://github.com/zeropynes/ETCMCLXCScripts/raw/refs/heads/main/update_scripts.sh | sh

echo 'ETCMC Scripts Updated. You can start your ETCMC Node now...'
EOF
chmod +x /root/etcmc/scripts_update.sh 

clear
echo 'Creating ETCMC Service Script...'
sleep 5

cat << EOF > /etc/systemd/system/etcmc.service
[Unit]
Description=ETCMC
After=network.target

[Service]
User=root
Group=root
ExecStartPre=/bin/sleep 20
ExecStart=/root/etcmc/start.sh
WorkingDirectory=/root/etcmc
StandardOutput=append:/var/log/etcmcscript.log
StandardError=append:/var/log/etcmcscript.log
Environment=PATH=/usr/local/bin:/usr/bin:/bin
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /etc/systemd/system/etcmcstop.service
[Unit]
Description=ETCMC Node prior shutdown
Requires=network-online.target
After=network-online.target


[Service]
User=root
Group=root
Type=oneshot
TimeoutStopSec=infinity
RemainAfterExit=true
ExecStop=/usr/bin/python3 /root/etcmc/Linux.py stop

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable etcmc.service
systemctl enable etcmcstop.service
clear
echo 'Checking for update..'
sleep 5
python3 Linux.py update
pip3 install -r requirements.txt --break-system-packages --ignore-installed
#pip3 install plyer websockets aiohttp --ignore-installed
#pip3 install flask --ignore-installed

echo 'Installation complete... Rebooting ETCMC Node in 20 seconds...'
echo 'Once the reboot is complete, the ETCMC Node will start automatically. '
echo 'Please wait until the reboot is finished, then access the Node Web UI at:'
my_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
echo "http://$my_ip:5000"
sleep 20

clear
echo 'Please Reboot Manually...'
echo "\n"
#/sbin/reboot

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