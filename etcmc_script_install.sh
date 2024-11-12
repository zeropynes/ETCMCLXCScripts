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

cat << EOF > ~/etcmc/start.sh
#!/bin/sh
#creating etcmc screen session as detached
screen -dmS etcmc

#starting etcmc node on port 5000 and exit screen session immediately when stopped
screen -S etcmc -X stuff "/usr/bin/python3 /root/etcmc/Linux.py start --port 5000\n" 1>/dev/null 2>&1
screen -S etcmc -X quit 1>/dev/null 2>&1
EOF
chmod +x start.sh

cat << EOF > ~/etcmc/stop.sh
#!/bin/sh
#stopping etcmc node
python3 Linux.py stop
EOF
chmod +x stop.sh

cat << EOF > ~/etcmc/poweroff.sh
#!/bin/sh
#stopping etcmc node
~/etcmc/stop.sh

#powering down machine
poweroff
EOF
chmod +x poweroff.sh

cat << EOF > ~/etcmc/update.sh
#!/bin/sh
#stopping etcmc node
~/etcmc/stop.sh

#updating etcmc node
python3 Linux.py update

echo 'ETCMC Updated. Starting ETCMC Node now...' 
sleep 5

#starting etcmc node
~/etcmc/start.sh
EOF
chmod +x update.sh

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