# WireGuard Network Namespace Management Scripts For Linux

This script collection simplifies the management of one (or multiple) WireGuard VPN configurations running in separate network namespaces. The scripts manage the installation, starting, and stopping aswell as execution of commands within the namespaces.

To ensure a safe and reliable installation, the script uses the `ip` command to initiate all interfaces and specifies the type as `wireguard` along with a `network brige` setup. This eliminates the need to alter any iptables rules to route packets correctly.

## Prerequisites

To use these scripts, you must have the following programs installed on your system:

- `wireguard`: Provides the WireGuard VPN kernel module and user-space utilities.
- `iproute2`: Provides the `ip` command for managing network namespaces.
- `nmcli`: NetworkManager command-line tool.

```bash
sudo apt-get install wireguard iproute2 network-manager
```

## Example Usage: BitTorrent Client Start in WG-Namespace
To start and execute a BitTorrent client (example Qbittorrent) in a isolated wireguard enviroment, here with name `netns` you could do the following.
```bash
# Install bridge and start the namespace
sudo wg-netns-install
sudo wg-netns-start /path/to/wg.conf netns

# Confirm your namepspace traffic is routed via the endpoint vpn server
sudo wg-netns-execute netns "curl ifconfig.me/ip"

# Start the torrent client in the namespace with the QbitUser user.
sudo wg-netns-execute netns "runuser -u QbitUser /usr/bin/qbittorrent-nox"

# Please note that to reach qbittorrent from outside the namespace, the virtual ip address must be used. 
# The ip assigned to the wireguard veth in the start script is currently 192.168.12.2.

```

Bring the network namespace down
```bash
sudo wg-netns-stop netnsname
```
Remove all traces of the scripts
```bash
sudo wg-netns-remove
```

```diff
! Please note that the changes implemeted by the wg-netns-start command doesn't survive reboot.
```
## System Service Setup for Persistent Install
To make a persistent namespace install that survives reboot of the system, it's suggested to run the `wg-netns-start` via a system service.

Create a new system service file
```bash
sudo emacs /path/to/systemd/service/wg-namespace.service
```
Configure the service to run the start and stop scripts on start and stop of service.
```
[Unit]
Description=WireGuard VPN instance in a network namespace
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
User=root
ExecStart=/path/to/wg-netns-start /path/to/wg.conf netns
ExecStop=/path/to/wg-netns-stop nets

[Install]
WantedBy=multi-user.targe
```
Start and enable the wireguard service
```
sudo systemctl start wg-namespace.service
sudo systemctl status wg-namespace.service
sudo systemctl enable wg-namespace.service
```

In the example of Qbittorrent, change the ExecStart and User in the `qbittorrent-nox.service` to
```
User=root
ExecStart=/path/to/wg-netns-execute netns "runuser -u QbitUser /usr/bin/qbittorrent-nox"

# Optional but recommended line to make sure Qbittorrent can't be run without the wg namespace service running
Requires=wg-namespace.service
```

## Configuration File

These are the current known supported configuration parameters for the client configuration.
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
./wg-netns-shell netnsname
```

4. `wg-netns-execute`: Executes a command in the specified namespace.

```bash
./wg-netns-execute netnsname "curl ifconfig.me/ip"
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

These scripts have only been tested with Mullvad VPN. The scripts do not support IPv6 addresses in the configuration file. When choosing an identifier name, please avoid using hyphens (-) or underscores (_) to ensure proper functioning. I take no responsibility of failiure of scripts, use at own risk. Always confirm that the setups are working vigorously.

