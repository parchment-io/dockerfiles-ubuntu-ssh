## dockerfiles-ubuntu-ssh

This image is a basic Ubuntu image with `ssh` installed and a scripted startup to allow creation of user accounts with corresponding SSH keys.

Mount authorized_keys files in `/opt/ssh_keys` named as the desired user to be created (any extension will be stripped).

Persistent storage can be mounted at `/home` and `/etc/ssh/keys` if you wish the user home directories and SSH host keys to be maintained between container runs.
