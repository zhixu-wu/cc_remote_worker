#!/bin/bash
# Generic SSH executor using servers.conf
# Usage: ./ssh_exec.sh <server_alias> "command"

ALIAS="${1}"
shift
COMMAND="$@"

if [ -z "$ALIAS" ]; then
    echo "Usage: ./ssh_exec.sh <server_alias> \"command\""
    echo ""
    echo "Available servers:"
    if [ -f servers.conf ]; then
        grep -v '^#' servers.conf | grep -v '^$' | cut -d'|' -f1 | sed 's/^/  - /'
    else
        echo "  No servers configured (servers.conf not found)"
    fi
    exit 1
fi

if [ ! -f servers.conf ]; then
    echo "Error: servers.conf not found"
    echo "Create servers.conf with format: ALIAS|HOST|PORT|USER|PASSWORD"
    exit 1
fi

# Read server config
SERVER_LINE=$(grep "^${ALIAS}|" servers.conf)
if [ -z "$SERVER_LINE" ]; then
    echo "Error: Server alias '${ALIAS}' not found in servers.conf"
    echo ""
    echo "Available servers:"
    grep -v '^#' servers.conf | grep -v '^$' | cut -d'|' -f1 | sed 's/^/  - /'
    exit 1
fi

IFS='|' read -r _ HOST PORT USER PASSWORD <<< "$SERVER_LINE"

# Execute SSH command
sshpass -p "${PASSWORD}" ssh -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -o ServerAliveInterval=60 \
  -p "${PORT}" "${USER}@${HOST}" "$COMMAND"
