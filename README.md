# 🖥️ TDE Installer (Termux Desktop Environment)

A simple script to install a lightweight desktop environment in Termux with:

- XFCE / LXDE / LXQT / i3 / IceWM
- Termux X11 or VNC support
- Minimal install using `--no-install-recommends`
## 📸 Screenshot

![Preview](Screenshot_20260419-122704.png)
---

## ⚡ Features

- Clean interactive installer
- Lightweight installs (saves storage)
- Auto-generated start commands
- Supports both X11 and VNC

---

## 📥 Installation

```bash
pkg update && pkg upgrade
pkg install git
git clone https://github.com/AppNotFound/tde-installer.git
cd tde-installer
chmod +x install.sh
./install.sh
