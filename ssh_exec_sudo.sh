#!/bin/bash
# SSH executor with sudo support for aliyun_hawkbit

ALIAS="${1}"
shift
COMMAND="$@"

if [ ! -f servers.conf ]; then
    echo "Error: servers.conf not found"
    exit 1
fi

# Read server config
SERVER_LINE=$(grep "^${ALIAS}|" servers.conf | grep -v "^#")
if [ -z "$SERVER_LINE" ]; then
    echo "Error: Server alias '${ALIAS}' not found"
    exit 1
fi

IFS='|' read -r _ HOST PORT USER AUTH <<< "$SERVER_LINE"

# For aliyun_hawkbit, use sudo password
SUDO_PASSWORD="DexManager!"

# Detect if AUTH is a file path (SSH key) or password
if [ -f "$AUTH" ]; then
    # SSH key authentication with sudo
    echo "$SUDO_PASSWORD" | ssh -i "$AUTH" -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      -o ServerAliveInterval=60 \
      -p "${PORT}" "${USER}@${HOST}" "sudo -S bash -c '$COMMAND'"
else
    # Password authentication with sudo
    echo "$SUDO_PASSWORD" | sshpass -p "${AUTH}" ssh -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      -o ServerAliveInterval=60 \
      -p "${PORT}" "${USER}@${HOST}" "sudo -S bash -c '$COMMAND'"
fi
