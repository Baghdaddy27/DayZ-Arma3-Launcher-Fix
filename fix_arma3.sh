#!/bin/bash

# Step 1: Detect Steam Installation (Native or Flatpak)
if command -v steam &> /dev/null; then
    STEAM_DIR="$HOME/.local/share/Steam"
elif command -v flatpak &> /dev/null && flatpak list | grep -q com.valvesoftware.Steam; then
    STEAM_DIR="$HOME/.var/app/com.valvesoftware.Steam/data/Steam"
else
    echo "⚠️ Steam is not installed or not found!"
    exit 1
fi

# Step 2: Define ARMA 3 Proton Prefix Path
ARMA3_PREFIX="$STEAM_DIR/steamapps/compatdata/107410/pfx"

# Step 3: Create Required Windows-Like Directories Inside Proton Prefix
echo "📁 Creating necessary directories for ARMA 3..."
mkdir -p "$ARMA3_PREFIX/drive_c/Users/$USER/AppData/Local"
mkdir -p "$ARMA3_PREFIX/drive_c/Users/$USER/AppData/Roaming"
mkdir -p "$ARMA3_PREFIX/drive_c/Users/$USER/Documents"
mkdir -p "$ARMA3_PREFIX/drive_c/Users/$USER/Saved Games"

# Step 4: Link Steam Workshop Mods to Proton Prefix
echo "🔗 Linking Steam Workshop Mods to ARMA 3..."
WORKSHOP_MODS="$STEAM_DIR/steamapps/workshop/content/107410"
MOD_DEST="$ARMA3_PREFIX/drive_c/users/steamuser/Documents/Arma 3 Mods"

if [ -d "$WORKSHOP_MODS" ]; then
    ln -sf "$WORKSHOP_MODS" "$MOD_DEST"
    echo "✅ Mods linked successfully!"
else
    echo "⚠️ No mods found in Steam Workshop!"
fi

# Step 5: Fix UI Scaling (Optional)
echo "🖥️ Configuring UI scaling..."
WINECFG_CMD="WINEPREFIX=$ARMA3_PREFIX winecfg"

echo "Run the following command and set DPI scaling to 200 in the Graphics tab:"
echo "$WINECFG_CMD"

# Done
echo "✅ ARMA 3 Fix Applied! Restart Steam and try launching the game."
