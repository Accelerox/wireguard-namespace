#!/bin/bash

# This script starts a new bash shell in the specified namespace.
# The new bash shell displays the unique identifier name in the prompt.
# The specified user will be used in the new bash session.
#
# Usage: sudo ./vpn-shell.sh <identifier> <user-name>

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo"
    exit 1
fi

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <identifier> <user-name>"
    exit 1
fi

identifier=$1
user_name=$2

# Check if the namespace exists
if ! ip netns list | grep -q -w "${identifier}"; then
    echo "Namespace '${identifier}' not found"
    exit 1
fi

# Set the custom PS1 with colors and font as an environment variable
custom_ps1="\[\e]0;\u@${identifier}: \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@${identifier}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Start a new bash shell in the specified namespace with the unique identifier in the prompt
# Use the specified user in the new bash session
ip netns exec ${identifier} runuser -u ${user_name} -- env PS1="${custom_ps1}" /bin/bash --norc --noprofile