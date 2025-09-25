#!/bin/bash
set -e
echo "Testing ECA mise tool plugin..."
MISE_VERBOSE=1 mise plugin link eca . || true
mise install eca@latest
mise use -g eca@latest
eca --version
timeout 5s eca server --help || true
echo "All tests passed!"
mise plugin uninstall -p eca
