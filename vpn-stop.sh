#!/bin/bash

# This script stops a WireGuard VPN instance with the given identifier.
# It removes the corresponding namespace, bridge connection, and virtual Ethernet (veth) interfaces.
#
# Usage: ./vpn-stop.sh <identifier>

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo"
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <identifier>"
    exit 1
fi

identifier=$1

# Remove the namespace
ip netns del ${identifier}

# Remove the bridge connection to the namespace
ip link del veth-nsbr-${identifier}

# Remove the virtual Ethernet (veth) interfaces
ip link del veth-init-${identifier}

# Remove the WireGuard interface from the default/init namespace
#ip link del wg0-${identifier}

# Remove the namespace folder
rm -rf /etc/netns/${identifier}

#!/bin/bash

# This script stops a WireGuard VPN instance with the given identifier.
# It removes the corresponding namespace, bridge connection, and virtual Ethernet (veth) interfaces.
#
# Usage: ./vpn-stop.sh <identifier>

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <identifier>"
    exit 1
fi

identifier=$1

# Remove the namespace
ip netns del ${identifier}

# Remove the bridge connection to the namespace
ip link del veth-nsbr-${identifier}

# Remove the virtual Ethernet (veth) interfaces
ip link del veth-init-${identifier}

# Remove the WireGuard interface from the default/init namespace
#ip link del wg0-${identifier}

# Remove the namespace folder
rm -rf /etc/netns/${identifier}

echo "Namespace and veth config for $identifier removed."
