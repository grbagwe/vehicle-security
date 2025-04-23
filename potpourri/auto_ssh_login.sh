#!/bin/bash

# Prompt for username
read -p "Enter your Palmetto username: " USERNAME

# Generate SSH key (if it doesn't exist)
KEY_PATH="$HOME/.ssh/id_ed25519"
if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key at $KEY_PATH"
    ssh-keygen -t ed25519 -C "$USERNAME@palmetto" -f "$KEY_PATH" -N ""
else
    echo "SSH key already exists at $KEY_PATH"
fi

# Create sockets directory
SOCKET_DIR="$HOME/.ssh/sockets"
mkdir -p "$SOCKET_DIR"
chmod 700 "$SOCKET_DIR"

# Append SSH config for Palmetto (if not already present)
CONFIG_BLOCK="
Host palmetto
    HostName slogin.palmetto.clemson.edu
    User $USERNAME
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 2h
"
CONFIG_FILE="$HOME/.ssh/config"

if ! grep -q "Host palmetto" "$CONFIG_FILE" 2>/dev/null; then
    echo "Adding Palmetto config to $CONFIG_FILE"
    echo "$CONFIG_BLOCK" >> "$CONFIG_FILE"
else
    echo "Palmetto config already exists in $CONFIG_FILE"
fi

# Copy SSH key to Palmetto
echo "Copying SSH public key to Palmetto..."
ssh-copy-id palmetto

echo "✅ Setup complete. Try connecting with: ssh palmetto"

