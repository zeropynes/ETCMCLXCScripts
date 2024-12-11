#!/bin/sh

clear
echo 'Checking Scripts. Please wait...'

###scripts_update.sh
if [ -e scripts_update.sh ]
then
    rm scripts_update.sh 
fi

cat << EOF > /root/etcmc/scripts_update.sh 
#!/bin/sh

clear
wget -O - https://github.com/zeropynes/ETCMCLXCScripts/raw/refs/heads/main/update_scripts.sh | sh

echo 'ETCMC Scripts Updated. You can start your ETCMC Node now...'
EOF
chmod +x /root/etcmc/scripts_update.sh 

###start.sh
if [ -e start.sh ]
then
    rm start.sh 
fi

cat << EOF > /root/etcmc/start.sh
#!/bin/sh
# Creating etcmc screen session as detached
/usr/bin/screen -dmS etcmc

# Starting etcmc node on port 5000 and exit screen session immediately when stopped
/usr/bin/screen -S etcmc -X stuff "/usr/bin/python3 /root/etcmc/Linux.py start --port 5000\n" 1>/dev/null 2>&1
/usr/bin/screen -S etcmc -X stuff "exit\n" 1>/dev/null 2>&1
EOF
chmod +x /root/etcmc/start.sh

###stop.sh
if [ -e stop.sh ]
then
    rm stop.sh 
fi

cat << EOF > /root/etcmc/stop.sh
#!/bin/sh
# Stopping etcmc node
/usr/bin/python3 /root/etcmc/Linux.py stop
EOF
chmod +x /root/etcmc/stop.sh

###poweroff.sh
if [ -e poweroff.sh ]
then
    rm poweroff.sh 
fi

cat << EOF > /root/etcmc/poweroff.sh
#!/bin/sh
# Stopping etcmc node
/root/etcmc/stop.sh

# Powering down machine
/sbin/poweroff
EOF
chmod +x /root/etcmc/poweroff.sh

###update.sh
if [ -e update.sh ]
then
    rm update.sh 
fi

cat << EOF > /root/etcmc/update.sh
#!/bin/sh
python3 Linux.py stop
python3 Linux.py update
pip3 install plyer websockets aiohttp --ignore-installed
pip3 install flask --ignore-installed
echo 'ETCMC Updated. Starting ETCMC Node now...'
sleep 5
./start.sh
EOF
chmod +x /root/etcmc/update.sh

###config_update.sh
if [ -e config_update.sh ]
then
    rm config_update.sh 
fi

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
