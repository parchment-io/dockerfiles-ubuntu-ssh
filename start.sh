#!/bin/bash

rm -fr /run/sshd/*
mkdir -p /opt/user_keys
for keyfile in $(find /opt/user_keys -type f); do
  user=$(basename $keyfile | cut -d. -f1)
  echo "Creating user $user"
  if [ -d /home/$user ]; then
    uid=$(stat -c '%u' /home/$user)
    gid=$(stat -c '%g' /home/$user)
    echo "/home/$user already exists. Using uid $uid, gid $gid"
    groupadd -g $gid $user
    useradd -u $uid -g $gid -s /bin/bash $user
  else
    useradd -m -s /bin/bash $user
  fi
  mkdir -p /home/$user/.ssh
  chown $user:$user /home/$user/.ssh
  chmod 700 /home/$user/.ssh
  cp $keyfile /home/$user/.ssh/authorized_keys
  chown $user:$user /home/$user/.ssh/authorized_keys
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
