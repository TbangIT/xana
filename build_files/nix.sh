systemctl enable podman.socket

#!/usr/bin/env bash
source /ctx/common


# Create a tmpfile config to create the /var/nix directory on boot
cat <<EOF > /usr/lib/tmpfiles.d/nix.conf
# Create /var/nix directory
d /var/nix 0775 root nix -
EOF

# Create a bind mount for Nix
# Nix doesn't seem to appreciate having a symlink
cat <<EOF > /usr/lib/systemd/system/nix.mount
[Unit]
Description=Bind mount /var/nix to /nix
Before=local-fs.target

[Mount]
What=/var/nix
Where=/nix
Type=none
Options=bind

[Install]
WantedBy=local-fs.target
EOF

# Create nix-daemon overrides
mkdir -p /usr/lib/systemd/system/nix-daemon.service.d
cat <<EOF > /usr/lib/systemd/system/nix-daemon.service.d/override.conf
[Unit]
After=nix.mount
Requires=nix.mount
EOF

# Enable the Nix Repo
dnf5 -y -q copr enable petersen/nix >/dev/null 2>&1 

# Install Nix
DNF nix
DNF nix-daemon

# Enable the Nix Daemon (to enable Nix for all users)
systemctl enable nix.mount
systemctl enable nix-daemon.service

# Disable the Nix Repo
dnf5 -y -q copr disable petersen/nix >/dev/null 2>&1
