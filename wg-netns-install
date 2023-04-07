#!/bin/bash

# This script sets up a bridge interface (br0) on your system.
#
# Usage: ./vpn-install.sh

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo"
    exit 1
fi

# Create bridge br0
nmcli connection add type bridge ifname br0 stp no
