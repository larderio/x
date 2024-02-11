#!/usr/bin/env bash

set -eu

apt install openssh-server -y

C="/etc/ssh/sshd_config"
echo "ClientAliveInterval 120" >>$C
echo "PasswordAuthentication no" >>$C
echo "Protocol 2" >>$C
echo "PermitRootLogin yes" >>$C
echo "TCPKeepAlive yes" >>$C
echo "X11Forwarding yes" >>$C
echo "X11DisplayOffset 10" >>$C
echo "PubkeyAuthentication yes" >>$C
echo "IgnoreRhosts yes" >>$C
echo "HostbasedAuthentication no" >>$C
echo "PrintLastLog yes" >>$C
echo "AcceptEnv LANG LC_*" >>$C

mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo "$PUBKEY" >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

ssh-keygen -A

service ssh start
