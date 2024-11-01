#!/bin/sh

echo 'Updating Linux...'
apt update 
apt dist-upgrade -y 
clear
echo 'Initializing ETCMC Linux Installation...'
sleep 5
mkdir etcmc 
wget https://github.com/Nowalski/ETCMC_Software/releases/download/Setup%2FWindows/ETCMC_Linux.zip 
clear
echo 'Installing ETCMC Linux...'
sleep 5
apt install unzip python3 python3-pip screen -y 
unzip ETCMC_Linux.zip -d etcmc 
chmod -R 777 etcmc/ 
cd etcmc/ 
pip install -r requirements.txt 
chmod +x Linux.py ETCMC_GETH.py updater.py geth
clear
echo 'Creating ETCMC Linux Scripts...'
sleep 5
touch start.sh 
chmod +x start.sh 
{ echo '#!/bin/sh' ; echo 'screen -dmS etcmc' ; echo 'screen -S etcmc -X stuff "/usr/bin/python3 /root/etcmc/Linux.py start --port 5000\n" 1>/dev/null 2>&1' ; echo 'screen -S etcmc -X stuff "exit\n" 1>/dev/null 2>&1' ; } | tee -a /root/etcmc/start.sh
touch stop.sh 
chmod +x stop.sh 
{ echo '#!/bin/sh' ; echo 'python3 Linux.py stop' ; } | tee -a /root/etcmc/stop.sh
touch poweroff.sh 
chmod +x poweroff.sh 
{ echo '#!/bin/sh' ; echo '/usr/bin/python3 /root/etcmc/Linux.py stop' ; echo 'poweroff' ; }  | tee -a /root/etcmc/poweroff.sh 
touch update.sh 
chmod +x update.sh 
{ echo '#!/bin/sh' ; echo 'python3 Linux.py stop' ; echo 'python3 Linux.py update' ; echo 'ETCMC Updated. Starting ETCMC Node now...' ; echo './start.sh' ; } | tee -a /root/etcmc/update.sh
clear
echo 'Creating ETCMC Service Script...'
sleep 5
touch /etc/systemd/system/etcmc.service 
{ echo '[Unit]' ; echo 'Description=ETCMC' ; echo 'After=network.target' ; echo '' ; echo '[Service]' ; echo 'User=root' ; echo 'Group=root' ; echo 'ExecStartPre=/bin/sleep 20' ; echo 'ExecStart=/root/etcmc/start.sh' ; echo 'WorkingDirectory=/root/etcmc' ; echo 'StandardOutput=append:/var/log/etcmcscript.log' ; echo 'StandardError=append:/var/log/etcmcscript.log' ; echo 'Environment=PATH=/usr/local/bin:/usr/bin:/bin' ; echo 'RemainAfterExit=true' ; echo '' ; echo '[Install]' ; echo 'WantedBy=multi-user.target' ; }  | tee -a /etc/systemd/system/etcmc.service 
systemctl daemon-reload 
systemctl enable etcmc.service
clear
echo 'Installation complete... Rebooting ETCMC Node in 20 seconds...'
echo 'Once the Reboot is complete, the ETCMC Node will start automatically. You can then access the Node Web UI at:'
my_ip=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
echo 'http://'$my_ip':5000'
sleep 20
echo 'Rebooting...'
reboot