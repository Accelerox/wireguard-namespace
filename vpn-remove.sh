#!/bin/bash

# This script removes all WireGuard VPN instances, their corresponding namespaces, and the bridge.
#
# Usage: ./vpn-remove.sh

# Get a list of all the VPN instances' namespaces
namespaces=$(ip netns list | grep -E '^[a-zA-Z0-9_-]+$')

# Remove all the VPN instances' namespaces and their corresponding folders
for ns in $namespaces; do
    # Remove the namespace
    ip netns del ${ns}

    # Remove the bridge connection to the namespace
    ip link del veth-nsbr-${ns}

    # Remove the virtual Ethernet (veth) interfaces
    ip link del veth-init-${ns}

    # Remove the WireGuard interface from the default/init namespace
    ip link del wg0-${ns}

    # Remove the namespace folder
    rm -rf /etc/netns/${ns}
done

# Remove the bridge br0
nmcli connection delete br0
