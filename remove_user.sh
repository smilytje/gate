#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

read -e -p "Please enter the user you want to delete =>" user

function donef(){
  echo -e "
+-------------------------------------------+
The user | ${user} | has been deleted!
+-------------------------------------------+"
}

while true; do
  read -p "Do you want to delete ${user} [Y/N]" yn
    case $yn in
      [Yy]* ) sudo userdel $user & sudo rm -rf /home/$user && donef && exit 1 ;;
      [Nn]* ) read ;;
      * ) echo "Please answer yes or no.";;
    esac
done
