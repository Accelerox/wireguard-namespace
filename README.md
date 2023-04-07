# WireGuard Network Namespace Management Scripts For Linux

This script collection simplifies the management of multiple WireGuard VPN instances running in separate network namespaces. The scripts automate the installation, creation, and deletion of namespace configurations and execution of commands within the namespaces.

To ensure a safe and reliable installation, the script uses the `ip` command to initiate all interfaces and specifies the type as `wireguard`. This eliminates the need to alter any iptables rules to route packets correctly and avoids interference with other network configurations on the system.

## Prerequisites

To use these scripts, you must have the following programs installed on your system:

- `wireguard`: Provides the WireGuard VPN kernel module and user-space utilities.
- `iproute2`: Provides the `ip` command for managing network namespaces.
- `nmcli`: NetworkManager command-line tool.

```bash
sudo apt-get install wireguard iproute2 network-manager
```

## Example Usage
Install and execute a ip command from the network namespace
```bash
sudo wg-netns-install
sudo wg-netns-start /path/to/wg.conf netnsname
sudo wg-netns-execute netnsname "curl ifconfig.me/ip"
```
```diff
! Please note that the changes implemeted by the wg-netns-start command doesn't survive reboot.
```
Bring the network namespace down
```bash
sudo wg-netns-stop netnsname
```
Remove all traces of the scripts
```bash
sudo wg-netns-remove
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

1. `wg-netns-install`: Sets up a bridge named `br0`.

```bash
./wg-netns-install
```

2. `wg-netns-start`: Sets up a WireGuard VPN instance in a new network namespace using a specified configuration file and a unique identifier.

```bash
./wg-netns-start /path/to/config.conf netnsname
```

3. `wg-netns-shell`: Starts a new bash shell in the specified namespace, preserving the current user. The new bash shell displays the unique identifier name in the prompt.

```bash
./wg-netns-shell netnsname my-username
```

4. `wg-netns-execute`: Executes a command in the specified namespace.

```bash
./wg-netns-execute netnsname "ping google.com"
```

5. `wg-netns-stop`: Stops a WireGuard VPN instance with the given identifier and removes the corresponding namespace, bridge connection, and virtual Ethernet (veth) interfaces.

```bash
./wg-netns-stop netnsname
```

6. `wg-netns-remove`: Removes all WireGuard VPN instances, their corresponding namespaces, and the bridge.

```bash
./wg-netns-remove
```

To use these scripts, simply run them in the command line with the appropriate parameters.

## Disclaimer

These scripts have only been tested with Mullvad VPN. The scripts do not support IPv6 addresses in the configuration file. When choosing an identifier name, please avoid using hyphens (-) or underscores (_) to ensure proper functioning.

