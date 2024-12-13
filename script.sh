#!/bin/bash

# Variables
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")" # Directory where the script is located
TARGET_NODES=50
API_URL="https://api.etcnodes.org/peers?all=true"
ALL_NODES_FILE="reachablenodes.txt"
FILTERED_NODES_FILE="30303.txt"
PROVIDED_ENODES="bootstrap.txt"
MY_NODES="my_nodes.txt"
CONFIG_FILE="config.toml"
LOG_FILE="script_log.txt"

# Log message function
log_message() {
    local message="$1"
    local level="${2:-INFO}"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local formatted_message="[ $timestamp ] [ $level ] $message"
    echo -e "$formatted_message" >> "$LOG_FILE"
    echo -e "$formatted_message"
}

# Fetch and process nodes
fetch_and_process_nodes() {
    log_message "Fetching nodes from $API_URL"
    local response
    response=$(curl -s "$API_URL")
    
    if [[ -n "$response" ]]; then
        echo "$response" | jq -r '.[] | .enode' > "$ALL_NODES_FILE"
        log_message "Written all enodes to $ALL_NODES_FILE"
        
        grep ":30303" "$ALL_NODES_FILE" > "$FILTERED_NODES_FILE"
        local count
        count=$(wc -l < "$FILTERED_NODES_FILE")
        log_message "Filtered $count enodes for port 30303 and saved to $FILTERED_NODES_FILE"
    else
        log_message "Failed to fetch nodes or empty response received" "ERROR"
    fi
}

# Write configuration file
write_config_file() {
    local custom_port="$1"
    local destination_dir="$2"

    local my_nodes_string
    my_nodes_string=$(awk '{print "\"" $0 "\", "}' "$MY_NODES" | sed '$ s/, $//')
    local static_nodes
    static_nodes=$(awk '{print "\"" $0 "\", "}' "$FILTERED_NODES_FILE" | sed '$ s/, $//')
    local bootstrap_nodes
    bootstrap_nodes=$(awk '{print "\"" $0 "\", "}' "$PROVIDED_ENODES" | sed '$ s/, $//')

    cat <<EOF > "$destination_dir/$CONFIG_FILE"
# Ethereum Classic Node Configuration

[Eth]
# Network ID for Ethereum Classic
NetworkId = 61
# Sync mode (snap is faster for initial sync)
SyncMode = "snap"
# Other optimization parameters
NoPruning = false
NoPrefetch = false
LightPeers = 100
UltraLightFraction = 75
# Cache size for database in MB
DatabaseCache = 1024

[Node]
# Data directory for the Ethereum node data
DataDir = "./gethDataDirFastNode"
# Path to IPC file for inter-process communication
IPCPath = "geth.ipc"
# HTTP configurations for the node
HTTPHost = "localhost"
HTTPPort = 8544
HTTPCors = ["*"]
HTTPVirtualHosts = ["localhost"]
# Websocket configurations
WSHost = "localhost"
WSPort = 8546

[Node.P2P]
# Peer-to-peer configurations
MaxPeers = 15
NoDiscovery = false

# Add your bootstrap nodes here
BootstrapNodes = [
$bootstrap_nodes
]

# Add your static nodes here
StaticNodes = [
$my_nodes_string,
$static_nodes
]
EOF

    log_message "Configuration file created at $destination_dir/$CONFIG_FILE"
}

# Copy Config to Main Directory
copy_config() {
    local destination_dir="$1"
    log_message "Replacing old $CONFIG_FILE File"
    
    if [[ -e "$destination_dir/../$CONFIG_FILE" ]]; then
        rm "$destination_dir/../$CONFIG_FILE"
    fi

    cp "$CONFIG_FILE" "$destination_dir/../$CONFIG_FILE"
}

# Main script logic
clear
log_message "Script started."
DEST_DIR="$SCRIPT_DIR" # Set destination directory to the script's location

fetch_and_process_nodes
write_config_file 30303 "$DEST_DIR"

copy_config "$DEST_DIR"

log_message "Script completed successfully."
echo "Thank you for using this tool!"