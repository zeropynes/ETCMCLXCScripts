# ETCMC Scripts

**ETCMC Scripts** provides a quick and easy setup for running an ETCMC Node on an LXC (Linux Container) environment. This repository includes a one-click shell script, `etcmc_script_install.sh`, that automatically installs and configures the ETCMC Node, setting up all necessary dependencies, system services, and scripts.

### Features

- Automated installation of ETCMC Node on Linux
- Configures ETCMC Node service and essential scripts for starting, stopping, updating, and powering off the node
- Provides a Web UI for node management accessible after installation

### Installation

To install the ETCMC Node on your LXC, follow these steps:

**Download and Run the Installation Script**
   ```sh
   wget -O - https://github.com/zeropynes/ETCMCScripts/raw/refs/heads/main/etcmc_lxc_script_install.sh | sh
   ```


This script will:
- Update your Linux environment
- Install necessary dependencies
- Download and configure the ETCMC Node software
- Set up systemd service for automatic startup and management

### Access the Web UI

Once the installation is complete, the ETCMC Node will automatically reboot and start. You can then access the Web UI at:
```
http://<your_server_ip>:5000
```

### Additional Management Scripts

- `start.sh` - Start the ETCMC Node
- `stop.sh` - Stop the ETCMC Node
- `update.sh` - Stop, update, and restart the ETCMC Node
- `poweroff.sh` - Stop the node and power off the container

### Donations

If you would like to donate to a contributor, send ETC/ETCPOW to our wallet:

0xA24BC49b794b3bEc609aD72cD7017FFB6e784E2C