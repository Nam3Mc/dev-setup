#!/bin/bash
set -euo pipefail

echo "=== Blockchain Dev Environment Setup ==="

# --- Helper: check if a command exists ---
command_exists() {
  command -v "$1" &>/dev/null
}

# --- Install nvm (Node Version Manager) ---
if command_exists nvm; then
  echo "nvm already installed, skipping..."
else
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

  # Load nvm into this session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# --- Install Node.js 22 LTS via nvm ---
echo "Installing Node.js 22 LTS..."
nvm install 22
nvm use 22
nvm alias default 22

# --- Install pnpm ---
if command_exists pnpm; then
  echo "pnpm already installed, skipping..."
else
  echo "Installing pnpm..."
  npm install -g pnpm
fi

echo "=== Setup complete ==="
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"
echo "pnpm version: $(pnpm --version)"