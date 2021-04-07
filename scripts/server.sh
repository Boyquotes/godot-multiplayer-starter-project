#!/usr/bin/env bash
# Headless mode isn't available yet on Linux so we just start the editor in a really small window
godot --path ../ --server --no-window --resolution 1x1
