#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt update -y

apt purge *nvidia* -y
apt install nvidia-driver-530 -y

wget https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/default.cfg \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/katagoaaaaaaa \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/katagoaaaaaab \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/katagoaaaaaac \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/katagoaaaaaad \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/renju.bin.gzaaaaaaa \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/renju.bin.gzaaaaaab \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/renju.bin.gzaaaaaac \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/renju.bin.gzaaaaaad \
	https://cdn.jsdelivr.net/gh/larderio/x@content/katago-gomoku-opencl/renju.bin.gzaaaaaae

cat katago* >katago
cat renju.bin.gz* >renju.bin.gz

chmod +x katago

echo '#!/usr/bin/env bash' >colab-katago
echo '/content/katago gtp -model /content/renju.bin.gz -config /content/default.cfg' >>colab-katago

chmod +x colab-katago

apt install libzip4 -y
cp /lib/x86_64-linux-gnu/libzip.so.4 /lib/x86_64-linux-gnu/libzip.so.5
ldconfig

# Tune and quit, we are using pre-computed tuning
echo quit | ./colab-katago

mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo "$1" >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

apt install openssh-server -y

ssh-keygen -A

service ssh start

wget https://cdn.jsdelivr.net/gh/larderio/x@content/bore-v0.5.0-x86_64-unknown-linux-musl -O bore
chmod +x bore
./bore local 22 --to 194.135.104.187
