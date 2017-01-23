#!/bin/bash
# Rebooting vms after initialization

resumeVM() {
	virtual_machine_id=$1
	onevm resume $virtual_machine_id

	echo "Virtual machine $virtual_machine_id rebooted."
}

resumeUnknownVM() {
	virtual_machine_id=$1
	virtual_machine_status=$2

	echo "Virtual Machine: $virtual_machine_id    Status: $virtual_machine_status"

	if [ "$virtual_machine_status" != "runn" ]; then
		resumeVM $virtual_machine_id
		while [ "$?" == "1" ]; do
			resumeVM $virtual_machine_id
		done
	fi
}

trackVMs() {
	onevm list | grep 10.0.0 | awk {'print echo $1 " " $5'} | while read -r line; do resumeUnknownVM $line; done
}

waitServersInitialization() {
	# Testing the SSH connection with 10.0.0.2 (solarian) host
	s=$(ssh -q 10.0.0.2 exit; echo $?)

	# Test ssh connection each 3 seconds
	# The result $s should be 255 when ssh fails.
	while [ $s -ne 0 ]; do
		sleep 3
		s=$(ssh -q 10.0.0.2 exit; echo $?)
	done

	# Testing the SSH connection with 10.0.0.7 (imperius) host
	s=$(ssh -q 10.0.0.7 exit; echo $?)

	# Test ssh connection each 3 seconds
	# The result $s should be 255 when ssh fails.
	while [ $s -ne 0 ]; do
		sleep 3
		s=$(ssh -q 10.0.0.7 exit; echo $?)
	done
}

waitServicesInitialization(){
	s=$(ssh -q lappis@10.0.0.135 exit; echo $?)
	echo "testing: $s"
	# Test ssh connection each 3 seconds
	# The result $s should be 255 when ssh fails.
	while [ $s -ne 0 ]; do
	echo "testing: $s"
		sleep 3
		s=$(ssh -q lappis@10.0.0.135 exit; echo $?)
	done
}

configureExternalRoutes(){
	echo "Writing virtual machines routes."
	ssh lappis@10.0.0.135 "uproutes route" </dev/null
	sleep 1
	echo "Done."
}

waitFirewallInitialization(){
	# Testing the SSH connection with 10.0.0.131 (firewall) host
	s=$(ssh -q root@10.0.0.131 exit; echo $?)
	echo "testing: $s"
	# Test ssh connection each 3 seconds
	# The result $s should be 255 when ssh fails.
	while [ $s -ne 0 ]; do
	echo "testing: $s"
		sleep 3
		s=$(ssh -q root@10.0.0.131 exit; echo $?)
	done
}

configureExternalAccess(){
	echo "Creating IPTABLES rules @ firewall"
	ssh root@10.0.0.131 "/etc/iptables.up.rules" </dev/null
	sleep 1
	echo "Done."
}

waitServersInitialization
trackVMs

waitServicesInitialization
configureExternalRoutes

waitFirewallInitialization
configureExternalAccess
