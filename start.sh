#!/bin/bash

mkdir -p /opt/ssh_keys
for keyfile in $(find /opt/ssh_keys -type f); do
  user=$(basename $keyfile | cut -d. -f1)
  echo "Creating $user and copying keyfile to authorized_keys"
  useradd -m $user
  mkdir /home/$user/.ssh
  chown $user:$user /home/$user/.ssh
  chmod 700 /home/$user/.ssh
  cp $keyfile /home/$user/.ssh/authorized_keys
done

if [ ! -f /etc/ssh/keys/ssh_host_rsa_key ]; then
  ssh-keygen -t rsa -f /etc/ssh/keys/ssh_host_rsa_key -P ''
fi
if [ ! -f /etc/ssh/keys/ssh_host_ecdsa_key ]; then
  ssh-keygen -t ecdsa -f /etc/ssh/keys/ssh_host_ecdsa_key -P ''
fi
if [ ! -f /etc/ssh/keys/ssh_host_ed25519_key ]; then
  ssh-keygen -t ed25519 -f /etc/ssh/keys/ssh_host_ed25519_key -P ''
fi

/usr/sbin/sshd -D -e
