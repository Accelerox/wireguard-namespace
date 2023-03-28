#!/bin/bash

# This script sets up a bridge interface (br0) on your system.
#
# Usage: ./vpn-install.sh

# Create bridge br0
nmcli connection add type bridge ifname br0 stp no
