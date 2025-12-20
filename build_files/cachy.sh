#!/bin/bash

set -ouex pipefail

echo "### Inizio installazione CachyOS Kernel & UKSMD ###"

# 1. Scarica i Repo
# Usiamo -O per salvare i file nella cartella corretta
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-addons-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_cachyos-addons.repo
wget https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$(rpm -E %fedora)/bieszczaders-kernel-cachyos-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_cachyos.repo
dnf remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra -y

dnf install libcap-ng libcap-ng-devel procps-ng procps-ng-devel -y #uksmd

dnf install -y --allowerasing \
    kernel-cachyos \
    kernel-cachyos-devel \
    kernel-cachyos-headers \
    kernel-cachyos-modules \
    kernel-cachyos-modules-extra

systemctl enable uksmd.service
