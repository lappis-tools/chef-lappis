#! /bin/bash

if [[ $USER != "root" ]]; then
	echo "You should execute this script as root"
	exit 1
fi

mkdir -p /etc/lappis.conf
cp lappis-controller.conf /etc/lappis.conf/routes.conf

cp lappis-controller.sh /usr/bin/uproutes
chmod 755 /usr/bin/uproutes
chown -R root:root /usr/bin/uproutes
sed -i "s/lappis-controller.conf/\/etc\/lappis.conf\/routes.conf/g" /usr/bin/uproutes


