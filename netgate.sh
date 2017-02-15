#!/bin/bash

# If you want to add more hosts EDIT the "host_list"

# Load hosts from file
location_log="/opt/netgate/host_list"

function host_list(){
  cat ${location_log} | awk '!/#/'| awk '{print $1}'
}

# Load host ip-address from file
function ip_fqdn(){
  grep -w "$host" ${location_log} | awk '{print $2}'
}

# Load login name from file
function login_name(){
  grep -w "$host" ${location_log} | awk '{print $3}'
}

function text(){
  echo -e "
+------------------------------------+
   You chose => \t ${host}
+------------------------------------+"
  echo ""
}

# Ssh function and log function. This function will start an ssh session and will log everything
function sshr(){
 mkdir -p /home/$(whoami)/log/${host}/
 ssh -l $(login_name) $(ip_fqdn) -i /home/$(whoami)/.ssh/id_rsa | tee -a /home/$(whoami)/log/${host}/$(date +'%Y.%m.%d-%R')_$(whoami).txt
}

function sticky(){
  text
  sshr
}

function exitf(){
  if [ "${host}" == "Exit" ]; then
    echo ""
    echo "Bye-Bye"
    exit
  fi
}

# This function will bring all the other function together and apply it on the chosen host from the menu.
function loop(){
  for host in ${options[@]}; do
    [[ "$host1" == "$host" ]] && {
        exitf
        sticky
    }
  done
}

# Creating a menu, setting up the options and adding the loop function
echo ""
PS3="
Please select a host => "
echo ""


options=("$(host_list)" "Exit")

select host1 in ${options[@]}; do
  loop
done

echo -ne '\n'
