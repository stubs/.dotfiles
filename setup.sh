#!/usr/bin/env bash

set -e

UV_VERSION="0.9.4"

# Install uv
echo "Installing uv ${UV_VERSION}..."
if ! command -v uv &> /dev/null; then
    curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | env UV_NO_MODIFY_PATH=1 sh
fi

# Symlink uv to /usr/local/bin
if [ -f "$HOME/.local/bin/uv" ]; then
    sudo ln -sf "$HOME/.local/bin/uv" /usr/local/bin/uv
    echo "✅ uv symlinked to /usr/local/bin"
elif [ -f "$HOME/.cargo/bin/uv" ]; then
    sudo ln -sf "$HOME/.cargo/bin/uv" /usr/local/bin/uv
    echo "✅ uv symlinked to /usr/local/bin"
fi

echo "✅ uv installation complete!"
echo ""
echo "🚀 Starting complete dotfiles setup..."

./justfile setup