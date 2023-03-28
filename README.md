# WireGuard VPN Namespace Management Scripts

This collection of scripts helps you manage multiple WireGuard VPN instances running in separate network namespaces. 
The scripts automate the creation, deletion, and execution of commands in the namespaces. These scripts are designed for Linux systems.

## Prerequisites

To use these scripts, you must have the following programs installed on your system:

- `iproute2`: Provides the `ip` command for managing network namespaces.
- `wireguard`: Provides the WireGuard VPN kernel module and user-space utilities.
- `bash`: Provides the shell used by the scripts.
- `nmcli`: NetworkManager command-line tool (optional, used by the bridge_install.sh script).

## Scripts

### 1. vpn-install.sh

This script sets up the bridge `br0` and disables the Spanning Tree Protocol (STP).

**Usage:**

vpn-install.sh

### 2. vpn-start.sh

This script sets up a WireGuard VPN instance in a new network namespace using a specified configuration file and a unique identifier.

**Usage:**

$ ./vpn-start.sh <configuration_file> <identifier>

Replace `<configuration_file>` with the path to the configuration file and `<identifier>` with a unique name to create a new instance.

### 3. vpn-stop.sh

This script stops a WireGuard VPN instance with the given identifier and removes the corresponding namespace, bridge connection, and virtual Ethernet (veth) interfaces.

**Usage:**

$ ./vpn-stop.sh <identifier>

Replace `<identifier>` with the name of the VPN instance you want to stop.

### 4. vpn-remove.sh

This script removes all WireGuard VPN instances, their corresponding namespaces, and the bridge.

**Usage:**

$ ./vpn-remove.sh

### 5. vpn-shell.sh

This script starts a new bash shell in the specified namespace, preserving the current user. The new bash shell displays the unique identifier name in the prompt.

**Usage:**

$ ./vpn-shell.sh <identifier>

Replace `<identifier>` with the name of the VPN instance you want to enter.

### 6. vpn-execute.sh

This script takes an identifier and a command string as input and executes the command in the specified namespace.

**Usage:**

$ ./vpn-execute.sh <identifier> "<command>"

Replace `<identifier>` with the name of the namespace you want to execute the command in, and `<command>` with the command string you want to run.


