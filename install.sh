#!/data/data/com.termux/files/usr/bin/bash

# ===== COLORS =====
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[1;31m'
RESET='\033[0m'

clear

# ===== HEADER =====
echo -e "${CYAN}"
echo "======================================"
echo "      T D E   I N S T A L L E R"
echo "======================================"
echo "   Termux Native Desktop Setup Tool"
echo -e "${RESET}"
echo

TOTAL=6

# ===== STEP 1 =====
echo -e "${YELLOW}[1/$TOTAL] Updating system...${RESET}"
pkg update -y
pkg upgrade -y
echo

# ===== STEP 2 =====
echo -e "${YELLOW}[2/$TOTAL] Installing base packages...${RESET}"
pkg install x11-repo -y
echo

# ===== STEP 3 =====
echo -e "${YELLOW}[3/$TOTAL] Select Desktop Environment${RESET}"
echo "--------------------------------------"
echo " 1) XFCE"
echo " 2) LXDE"
echo " 3) LXQT"
echo " 4) i3"
echo " 5) i3WM"
echo "--------------------------------------"

read -p " Enter choice: " de_choice

case "$de_choice" in
  1)
    DE="xfce4"
    CMD="startxfce4"
    ;;
  2)
    DE="lxde"
    CMD="startlxde"
    ;;
  3)
    DE="lxqt"
    CMD="startlxqt"
    ;;
  4)
    DE="i3"
    CMD="i3"
    ;;
  5)
    DE="i3"
    CMD="i3"
    ;;
  *)
    echo -e "${RED}Invalid choice${RESET}"
    exit 1
    ;;
esac

echo -e "${GREEN}Installing $DE...${RESET}"
pkg install "$DE" --no-install-recommends -y
echo

# ===== STEP 4 =====
echo -e "${YELLOW}[4/$TOTAL] Select Display Method${RESET}"
echo "--------------------------------------"
echo " 1) Termux X11"
echo "    -> Install Termux:X11 app"
echo
echo " 2) VNC"
echo "    -> Install VNC Viewer"
echo "--------------------------------------"

read -p " Enter choice: " disp_choice

if [ "$disp_choice" = "1" ]; then
    TYPE="x11"
    pkg install termux-x11 -y
elif [ "$disp_choice" = "2" ]; then
    TYPE="vnc"
    pkg install tigervnc -y
else
    echo -e "${RED}Invalid choice${RESET}"
    exit 1
fi

echo

# ===== STEP 5 =====
echo -e "${YELLOW}[5/$TOTAL] Creating commands...${RESET}"

BIN="$PREFIX/bin"

if [ "$TYPE" = "x11" ]; then

cat > "$BIN/start-$DE-x11" <<EOF
#!/data/data/com.termux/files/usr/bin/bash

am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
termux-x11 :0 &
sleep 3

export DISPLAY=:0
export XDG_RUNTIME_DIR=\$TMPDIR

dbus-launch --exit-with-session $CMD
EOF

chmod +x "$BIN/start-$DE-x11"

cat > "$BIN/stop-$DE-x11" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
pkill termux-x11 2>/dev/null
pkill $CMD 2>/dev/null
EOF

chmod +x "$BIN/stop-$DE-x11"

fi

if [ "$TYPE" = "vnc" ]; then

cat > "$BIN/start-$DE-vnc" <<EOF
#!/data/data/com.termux/files/usr/bin/bash

vncserver -geometry 1280x720 :1
export DISPLAY=:1

$CMD
EOF

chmod +x "$BIN/start-$DE-vnc"

cat > "$BIN/stop-$DE-vnc" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
vncserver -kill :1
EOF

chmod +x "$BIN/stop-$DE-vnc"

fi

echo -e "${GREEN}Commands created successfully${RESET}"
echo

# ===== STEP 6 =====
echo -e "${YELLOW}[6/$TOTAL] Installing Firefox...${RESET}"
pkg install firefox -y

# ===== DONE =====
echo
echo -e "${CYAN}======================================${RESET}"
echo -e "${GREEN} Installation Complete ${RESET}"
echo -e "${CYAN}======================================${RESET}"
echo

if [ "$TYPE" = "x11" ]; then
    echo -e "${GREEN}X11 Commands:${RESET}"
    echo " start-$DE-x11"
    echo " stop-$DE-x11"
fi

if [ "$TYPE" = "vnc" ]; then
    echo -e "${GREEN}VNC Commands:${RESET}"
    echo " start-$DE-vnc"
    echo " stop-$DE-vnc"
    echo " connect -> localhost:1"
fi

echo
echo "Done."
