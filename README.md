# WireGuard Network Namespace Management Scripts For Linux

This script collection simplifies the management of multiple WireGuard VPN instances running in separate network namespaces. The scripts automate the installation, creation, and deletion of namespace configurations and execution of commands within the namespaces.

To ensure a safe and reliable installation, the script uses the `ip` command to initiate all interfaces and specifies the type as wireguard. This eliminates the need to alter any iptables rules to route packets correctly and avoids interference with other network configurations on the system.

## Prerequisites

To use these scripts, you must have the following programs installed on your system:

- `wireguard`: Provides the WireGuard VPN kernel module and user-space utilities.
- `iproute2`: Provides the `ip` command for managing network namespaces.
- `nmcli`: NetworkManager command-line tool (optional, used by the bridge_install.sh script).

## Example Usage
Install and execute a ip command from the network namespace
```
$ sudo wg-netns-install
$ sudo wg-netns-start /path/to/wg.conf netnsname
$ sudo wg-netns-execute netnsname "curl ifconfig.me/ip"
```
Bring the network namespace down
```
$ sudo wg-netns-stop netnsname
```
Remove all traces of the scripts
```
$ sudo wg-netns-remove
```

## Configuration File

To set up a VPN instance in a new network namespace using the scripts, you will need a standard WireGuard configuration file. The configuration file must include an `Address` field, which specifies the IP address and subnet mask for the WireGuard interface, as well as a `DNS` field.

The rest of the configuration should follow the standard WireGuard format, including fields such as `PrivateKey`, `PublicKey`, `AllowedIPs`, and `Endpoint`.

```
[Interface]
PrivateKey = EXAMPLE_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = EXAMPLE_PUBLIC_KEY
AllowedIPs = 0.0.0.0/0
Endpoint = example-vpn-server.com:51820
```

## Scripts

### 1. wg-netns-install

This script sets up a bridge named `br0`

**Usage:**

$ ./wg-netns-install

### 2. wg-netns-start

This script sets up a WireGuard VPN instance in a new network namespace using a specified configuration file and a unique identifier.

**Usage:**

$ ./wg-netns-start `<configuration_file>` `<identifier>`

Replace `<configuration_file>` with the path to the configuration file and `<identifier>` with a unique name to create a new instance.

### 3. wg-netns-stop

This script stops a WireGuard VPN instance with the given identifier and removes the corresponding namespace, bridge connection, 
and virtual Ethernet (veth) interfaces.

**Usage:**

$ ./wg-netns-stop `<identifier>`

Replace `<identifier>` with the name of the VPN instance you want to stop.

### 4. wg-netns-stop

This script removes all WireGuard VPN instances, their corresponding namespaces, and the bridge.

**Usage:**

$ ./wg-netns-remove

### 5. wg-netns-shell

This script starts a new bash shell in the specified namespace, preserving the current user. 
The new bash shell displays the unique identifier name in the prompt.

**Usage:**

$ ./wg-netns-shell `<identifier>` `<user-name>`

Replace `<identifier>` with the name of the VPN instance you want to enter and `<user-name>` with the user-id of the new shell.

### 6. wg-netns-execute

This script takes an identifier and a command string as input and executes the command in the specified namespace.

**Usage:**

$ ./wg-netns-execute `<identifier>` "`<command>`"

Replace `<identifier>` with the name of the namespace you want to execute the command in, and `<command>` with the command string you want to run.


## Disclaimer

These scripts have only been tested with Mullvad VPN. The scripts do not support IPv6 addresses in the configuration file. When choosing an identifier name, please avoid using hyphens (-) or underscores (_) to ensure proper functioning.

