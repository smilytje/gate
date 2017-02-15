#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

# Ask for a username

function askuser(){
  read -e -p "Please enter the username? => " user
  echo ""
}
# Check voor al bestaande account

function true(){
    echo -e "
+---------------------------------------+
   The user $user already exists!
+---------------------------------------+"
  echo ""
  exit
}

# Bevestiging dat gebruiker is toegevoegd

function donef(){
  echo -e "
+------------------------------------+
The user | $user | has been added!
+------------------------------------+"
  echo ""
}

# commandos om gebruiker en home aan te maken

function false(){
  sudo groupadd net_users >/dev/null 2>&1
  sudo useradd $user -g net_users
  sudo mkdir -p /home/$user/.ssh
  sudo cp /etc/pki/net/* /home/$user/.ssh/
  sudo chown -R $user:net_users /home/$user/
  sudo passwd $user
}

askuser
