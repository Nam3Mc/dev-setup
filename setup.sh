#!/bin/bash
set -euo pipefail

echo "=== Blockchain Dev Environment Setup ==="

# --- Helper ---
command_exists() {
  command -v "$1" &>/dev/null
}

# --- 1. curl (prerequisite) ---
if ! command_exists curl; then
  echo "Installing curl..."
  sudo apt update && sudo apt install -y curl
fi

# --- 2. nvm + Node.js 22 + pnpm ---
if command_exists nvm; then
  echo "nvm already installed."
else
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Ensure Node 22 is installed and active
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if node -v | grep -q "v22"; then
  echo "Node.js 22 already installed."
else
  echo "Installing Node.js 22 LTS..."
  nvm install 22
  nvm use 22
  nvm alias default 22
fi

if command_exists pnpm; then
  echo "pnpm already installed."
else
  echo "Installing pnpm..."
  npm install -g pnpm
fi

# --- 3. Docker check (install Docker Desktop on Windows separately) ---
if command_exists docker; then
  echo "Docker is available."
  docker --version
else
  echo "⚠️  Docker not found. Please install Docker Desktop for Windows and enable WSL integration."
  echo "   https://www.docker.com/products/docker-desktop/"
fi

# --- 4. Foundry ---
if command_exists forge; then
  echo "Foundry already installed."
else
  if ! command_exists foundryup; then
    echo "Installing foundryup..."
    curl -L https://foundry.paradigm.xyz | bash
    export PATH="$HOME/.foundry/bin:$PATH"
  fi
  echo "Running foundryup to install forge, cast, anvil..."
  foundryup
fi

echo ""
echo "=== Setup complete ==="
echo "Node: $(node --version)"
echo "pnpm: $(pnpm --version)"
echo "Docker: $(docker --version 2>/dev/null || echo 'not found')"
echo "Forge: $(forge --version 2>/dev/null || echo 'not found')"