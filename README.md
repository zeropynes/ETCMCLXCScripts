# ETCMC Scripts

**ETCMC Scripts** provides a quick and easy setup for running an ETCMC Node on an LXC (Linux Container) environment. This repository includes a one-click shell script, `etcmc_script_install.sh`, that automatically installs and configures the ETCMC Node, setting up all necessary dependencies, system services, and scripts.

### Features

- Automated installation of ETCMC Node on Linux
- Configures ETCMC Node service and essential scripts for starting, stopping, updating, and powering off the node
- Provides a Web UI for node management accessible after installation

### Installation

To install the ETCMC Node on your LXC, follow these steps:

1. **Download the Installation Script**
   ```sh
   git clone https://github.com/zeropynes/ETCMCScripts.git
   cd ETCMCScripts
   ```

2. **Run the Installation Script**
   ```sh
   sudo sh etcmc_script_install.sh
   ```

This script will:
- Update your Linux environment
- Install necessary dependencies
- Download and configure the ETCMC Node software
- Set up systemd service for automatic startup and management

### Access the Web UI

Once the installation is complete, the ETCMC Node will start automatically. You can access the Web UI at:
```
http://<your_server_ip>:5000
```

### Additional Management Scripts

- `start.sh` - Start the ETCMC Node
- `stop.sh` - Stop the ETCMC Node
- `update.sh` - Stop, update, and restart the ETCMC Node
- `poweroff.sh` - Stop the node and power off the container

