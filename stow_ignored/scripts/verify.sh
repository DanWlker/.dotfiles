#!/usr/bin/env bash

# Check if a file path is provided
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <package_file>"
  exit 1
fi

PACKAGE_FILE="$1"
missing=()

# Check if the file exists
if [[ ! -f "$PACKAGE_FILE" ]]; then
  echo "❌ Package file '$PACKAGE_FILE' not found."
  exit 1
fi

# Read and loop through each non-comment, non-empty line
while IFS= read -r pkg; do
  [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue

  if brew list --versions "$pkg" &>/dev/null; then
    echo "✅ $pkg is installed"
  else
    echo "❌ $pkg is NOT installed"
    missing+=("$pkg")
  fi
done < "$PACKAGE_FILE"

# Show missing packages
if [[ ${#missing[@]} > 0 ]]; then
  echo -e "\n📦 Missing packages:"
  for pkg in "${missing[@]}"; do
    echo "  - $pkg"
  done
else
  echo -e "\n🎉 All packages are installed!"
fi
