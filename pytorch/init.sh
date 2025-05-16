#!/bin/bash

set -eux
trap 'exit 0' SIGTERM

if [ -z "$AUTHORIZED_KEY_FILE" ]; then
    echo "Error: AUTHORIZED_KEY_FILE is not set."
    exit 1
fi

mkdir -p /home/devcontainer/.ssh
cp "$AUTHORIZED_KEY_FILE" /home/devcontainer/.ssh/authorized_keys
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy public key file."
    exit 1
fi
echo "Public key copied successfully."

# workspace permissions
chown -R devcontainer:devcontainer /home/devcontainer/workspaces
chmod -R 755 /home/devcontainer/workspaces

# freeze authorized_keys file 
chown -R root:root /home/devcontainer/.ssh
chmod 644 /home/devcontainer/.ssh/authorized_keys

echo "Starting SSH daemon..."
mkdir /run/sshd
chmod 755 /run/sshd
exec /usr/sbin/sshd -D 