#!/bin/bash

# This script executes the given command in the specified namespace.
# Make sure command is in quotes ""
# 
# Usage: ./vpn-execute.sh <identifier> "<command>"

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <identifier> <command>"
    exit 1
fi

identifier=$1
command=$2

# Check if the namespace exists
if ! ip netns list | grep -q -w "${identifier}"; then
    echo "Namespace '${identifier}' not found"
    exit 1
fi

# Execute the command in the specified namespace
ip netns exec ${identifier} bash -c "${command}"
