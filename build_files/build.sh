#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux 

# Install cromite from COPR
dnf5 -y copr enable atsitimolan/cromite
dnf5 -y install cromite
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging
FLATPAK_KILL_LIST=(
    "org.mozilla.firefox"
    "org.mozilla.Thunderbird"
    "org.kde.gwenview"        # Visualizzatore Immagini
    "org.kde.haruna"          # Video Player
    "org.kde.okular"          # PDF Reader
    "org.kde.kcalc"           # Calcolatrice
    "org.kde.skanpage"        # Scanner
    "org.kde.kontact"         # Suite contatti/mail
    "org.kde.kweather"        # Meteo
    "org.kde.kclock"
    "org.gnome.DejaDup"            # Backup
    "org.fedoraproject.MediaWriter"
)

for app in "${FLATPAK_KILL_LIST[@]}"; do
    if [ -d "/var/lib/flatpak/app/$app" ]; then
        rm -rf "/var/lib/flatpak/app/$app"
        echo "Rimosso App: $app"
    fi
done
flatpak uninstall --unused --system -y || true
#### Example for enabling a System Unit File

systemctl enable podman.socket
