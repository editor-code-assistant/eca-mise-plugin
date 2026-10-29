#!/bin/bash
set -e
echo "Testing ECA mise tool plugin..."
MISE_VERBOSE=1 mise plugin link eca . || true
mise install eca@latest
mise use -g eca@latest
eca --version
timeout 5s eca server --help || true

echo "Testing eca-cli..."
MISE_VERBOSE=1 mise plugin link eca-cli . || true
mise install eca-cli@latest
mise exec eca-cli@latest -- eca-cli --version

echo "All tests passed!"
mise plugin uninstall -p eca
mise plugin uninstall -p eca-cli
