#!/usr/bin/env bash

git config --global --add safe.directory /workspaces/orion
git config --global pull.rebase true
git submodule update --init --recursive

# install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

echo 'export PATH="$HOME/.local/bin:$PATH"'

# install packages
if [ -f .devcontainer/requirements.txt ]; then
    if command -v nvidia-smi &> /dev/null; then
        uv pip install --system --index-strategy unsafe-best-match \
            --extra-index-url https://download.pytorch.org/whl/cu124 \
            -r .devcontainer/requirements.txt
    else
        uv pip install --system --index-strategy unsafe-best-match \
            --extra-index-url https://download.pytorch.org/whl/cpu \
            -r .devcontainer/requirements-cpu.txt
    fi
else
    uv pip install --system --index-strategy unsafe-best-match \
        --extra-index-url https://download.pytorch.org/whl/cpu \
        -r .devcontainer/requirements-cpu.txt
fi


uv pip install -e .

cd src/app/
npm i

cd ../../
