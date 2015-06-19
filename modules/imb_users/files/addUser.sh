#! /bin/bash

NEW_USER_NAME="$1"
NEW_PASSWORD="$2"

# quietly add a user without password
useradd -d /home/$NEW_USER_NAME -s /bin/bash -p $(openssl passwd -1 $NEW_PASSWORD) -m $NEW_USER_NAME

# add user to the sudo group
adduser $NEW_USER_NAME sudo

# set the password to expiry
chage -d 0 $NEW_USER_NAME

