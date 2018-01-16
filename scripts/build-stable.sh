#!/bin/sh

url=$(curl -LsI -o /dev/null -w %{url_effective} https://nixos.org/releases/nixos/latest-iso-minimal-x86_64-linux)
chksum=$(curl "$url".sha256)

packer build --var "iso_url=$url" --var "iso_checksum=$chksum" "$@" nixos-stable-x86_64.json

# PACKER_LOG=1
# packer build packer_builds/nixos-18.03-x86_64.json
