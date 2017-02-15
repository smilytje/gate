#!/bin/bash

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

function gitf(){
    sudo rm -rf /opt/netgate
    cd /opt/
    echo -e "
    INFO: Cloning netgate "
    echo ""
    sudo git clone https://github.com/klinkk2306/netgate.git
    sudo rm -rf /usr/bin/netgate
}

function git_clone(){
  if [ -d "/opt/netgate/.git" ]; then
    echo -e "
    INFO: It looks like the netgate repo is cloned already."
    echo ""

    while true; do
      read -p "Do you want to update netgate? [Y/N]" yn
        case $yn in
          [Yy]* ) gitf; break;;
          [Nn]* ) exit 1 ;;
          * ) echo "Please answer yes or no.";;
        esac
      done
  else
    echo -e "
    INFO: Cloning netgate "
    echo ""
    cd /opt/
    sudo git clone https://github.com/klinkk2306/netgate.git
  fi
}

function symlink(){
 if [ -d "/opt/netgate/.git" ]; then
   sudo ln -s /opt/netgate/netgate.sh /usr/bin/netgate
   for i in list_users.sh add_user.sh remove_user.sh update; do
     sudo chmod +x /opt/netgate/${i}
   done
   sudo ln -s /opt/netgate/remove_user.sh /usr/bin/netgate-delete_user
   sudo ln -s /opt/netgate/update /usr/bin/netgate-update
   sudo ln -s /opt/netgate/list_users.sh /usr/bin/netgate-list_users
   sudo ln -s /opt/netgate/add_user.sh /usr/bin/netgate-new_user
   sudo chmod 777 /usr/bin/netgate
   sudo chmod 777 /usr/bin/netgate-new_user
   sudo chmod 777 /usr/bin/netgate-delete_user
   sudo chmod 777 /usr/bin/netgate-update
   sudo chmod 777 /usr/bin/netgate-list_users
 else
   echo -e "
   ERROR: Cannot access '/opt/netgate/'"
   echo ""

 fi
}

function sticky(){
  git_clone
  symlink
  sudo mkdir /usr/share/nano_keys
}

while true; do
    read -p "Do you wish to install netgate? [Y/N]" yn
    case $yn in
        [Yy]* ) sticky; break;;
        [Nn]* ) exit 1 ;;
        * ) echo "Please answer yes or no.";;
    esac
done
