#!/bin/bash
BIN_PATH="$HOME/.leeyc-script"

rm -r "$BIN_PATH"
mkdir "$BIN_PATH"
mkdir "$BIN_PATH/bin"


current_path=$(pwd)
cp -i "$current_path/script" "$BIN_PATH/bin"

echo "export PATH=\"$BIN_PATH/bin:\$PATH\"" >> ~/.zshrc
