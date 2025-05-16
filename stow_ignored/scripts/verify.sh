PACKAGE_FILE="$HOME/.dotfiles/stow_ignored/my_brews"

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
  fi
done < "$PACKAGE_FILE"
