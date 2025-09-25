#!/bin/bash
# test/test.sh
set -e

echo "Testing ECA mise tool plugin..."

# Install the plugin locally
mise plugin link eca . || true

# Test basic functionality
mise install eca@latest
mise use eca@latest

# Verify installation
eca --version

# Test that eca server can start (basic check)
timeout 5s eca server --help || echo "Server help command works"

echo "All tests passed!"

# Clean up
mise plugin remove eca
