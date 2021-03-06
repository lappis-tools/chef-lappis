#! /bin/bash

#####################################
#                                   #
# Author:  Luan Guimarães Lacerda   #
# Contact: livreluan@gmail.com      #
#                                   #
#####################################

command_arg=$1

INTERNAL_NETWORK="10.0.0.0"
EXTERNAL_NETWORK="164.41.86.0"
EXTERNAL_NETMASK="255.255.255.0"

getHostNetworkInterfaceName () {
  host_ip=$1
  remote_command="netstat -nr | grep $INTERNAL_NETWORK | tail -n1 | awk '{print \$NF}'"
  interface_name=$(ssh root@$host_ip $remote_command)
  echo $interface_name
}

enableExternalRoute () {
  host_ip=$1
  host_iface_name=$(getHostNetworkInterfaceName $host_ip)

  remote_command="sudo route add -net $EXTERNAL_NETWORK netmask $EXTERNAL_NETMASK dev $host_iface_name"
	ssh root@$host_ip $remote_command </dev/null
}

testConnection () {
	host_ip=$1
	host_iface_name=$(getHostNetworkInterfaceName $host_ip)

	remote_command="sudo date"
	ssh root@$host_ip $remote_command </dev/null
}

waitVMInitialization(){
	vm_ip=$1
	echo "Testing ssh for $vm_ip"
	counter=0
        ssh -q root@$vm_ip exit
        # Test ssh connection each 3 seconds
        # The result $s should be 255 when ssh fails.
        while ( [ $? -ne 0 ] && [ $counter -ne 3 ] ) ; do
        echo "Result: $?"
                sleep 10
		counter=$((counter+1))
                ssh -q root@$vm_ip exit
        done
}

while read -u10 line ; do
  splitted_line=( $line )
  host_name=${splitted_line[0]}
  host_ip=${splitted_line[1]}

	echo "Waiting $host_name initialization" 
	waitVMInitialization $host_ip
	
	if [ "$command_arg" == "route" ]; then
		echo "ENABLE EXTERNAL ROUTE TO: $host_name <$host_ip>";
		enableExternalRoute $host_ip
	elif [ "$command_arg" == "test" ]; then
		echo "TESTING SUDO COMMANDS FOR: $host_name <$host_ip>";
		testConnection $host_ip
		sleep 1
	else
		echo "SORRY, ERROR!"
	fi
done 10< lappis-controller.conf
