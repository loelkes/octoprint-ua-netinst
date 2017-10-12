#!/bin/bash

# System setting

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ $1 == 'firstboot' ]; then

	# Overclocking
	echo "arm_freq=1000" 	>> /boot/config.txt
	echo "sdram_freq=500" 	>> /boot/config.txt
	echo "core_freq=500" 	>> /boot/config.txt
	echo "over_voltage=6" 	>> /boot/config.txt
	echo "temp_limit=75" 	>> /boot/config.txt
	echo "boot_delay=" 	>> /boot/config.txt
	echo "dtparam=spi=on" 	>> /boot/config.txt #Enable SPI

	# Disable the splash screen
	echo "disable_splash=1" >> /boot/config.txt

	apt-get -y install rpi-update
	rpi-update
	rm /etc/cron.d/apa102-install
	echo "@reboot root /root/apa102.sh secondboot >> /var/log/apa102-ua-netinst.log 2>&1" > /etc/cron.d/apa102-install
	reboot

fi

if [ $1 == 'secondboot' ]; then

	# Install basic tools
	apt-get -y install nano screen python3 git python3-pip raspi-config libjpeg8-dev zlib1g-dev python3-numpy
	pip3 install spidev pillow websockets asyncio
  	cd ~
  	git clone https://github.com/loelkes/APA102_Pi.git
	rm /etc/cron.d/apa102-install
  
fi
