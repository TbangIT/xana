#!/usr/bin/env bash
source /ctx/common

PKGS=(
   greenboot
   greenboot-default-health-checks
)

DNF "${PKGS[@]}"

systemctl enable greenboot-healthcheck.service
