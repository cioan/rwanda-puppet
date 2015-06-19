#! /bin/bash

NEW_USER="$1"
NEW_PASSWORD="$2"

# quietly add a user without password
useradd -d /home/$NEW_USER -s /bin/bash -p $(openssl passwd -1 $NEW_PASSWORD) -m $NEW_USER

# add user to the sudo group
adduser $NEW_USER sudo

# set the password to expiry
chage -d 0 $NEW_USER

