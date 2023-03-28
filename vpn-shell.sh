#!/bin/bash

# This script starts a new bash shell in the specified namespace.
# The new bash shell displays the unique identifier name in the prompt.
# The current user will be preserved in the new bash session.
#
# Usage: ./vpn-shell.sh <identifier>

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <identifier>"
    exit 1
fi

identifier=$1

# Check if the namespace exists
if ! ip netns list | grep -q -w "${identifier}"; then
    echo "Namespace '${identifier}' not found"
    exit 1
fi

# Get the current user's ID
user_id=$(id -u)

# Start a new bash shell in the specified namespace with the unique identifier in the prompt
# Preserve the current user in the new bash session
PS1="[\u@${identifier}:\w]\$ " sudo -u "#${user_id}" ip netns exec ${identifier} bash --norc --noprofile
