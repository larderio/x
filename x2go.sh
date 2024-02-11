#!/usr/bin/env bash

service dbus start

apt update -y
apt install x2goserver

mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo "$1" >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

wget https://cdn.jsdelivr.net/gh/larderio/x@content/bore-v0.5.0-x86_64-unknown-linux-musl -O bore
chmod +x bore

./bore local 22 --to bore.pub
