#!/bin/sh

# System setting

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ $1 = 'configure_pi' ]; then

	# Overclocking
	echo "arm_freq=1000" >> /boot/config.txt
	echo "sdram_freq=500" >> /boot/config.txt
	echo "core_freq=500" >> /boot/config.txt
	echo "over_voltage=6" >> /boot/config.txt
	echo "temp_limit=75" >> /boot/config.txt
	echo "boot_delay=" >> /boot/config.txt

	# Disable the splash screen
	echo "disable_splash=1" >> /boot/config.txt



	apt-get -y install rpi-update
	rpi-update
	#echo "@reboot root /root/octoprint-ua-netinst.sh secondboot >> /var/log/octoprint-ua-netinst.log 2>&1" > /etc/cron.d/octoprint-install
	echo "Rebooting..."
	reboot

fi

if [ $1 = 'install_octoprint' ]; then

	# Install Octoprint and some basic tools
	apt-get -y install sudo nano screen python git python-pip python-dev libav-tools
	cd /root/
	git clone https://github.com/foosel/OctoPrint.git
	cd OctoPrint
	python setup.py install
	
	useradd -m -s /bin/bash octoprint
	usermod -a -G dialout octoprint
	
	sudo -u octoprint octoprint --daemon start
	echo "@reboot root sudo -u octoprint octoprint --daemon start" > /etc/cron.d/octoprint-daemon
fi

if [ $1 = 'install_mjpg-streamer' ]; then

	# Enable camera
	echo "start_x=1" >> /boot/config.txt
	
	# Give GPU some memory
	echo "gpu_mem=128" >> /boot/config.txt

	## Install mjpeg-streamer
	cd /root/
	apt-get -y install libjpeg8-dev cmake
	git clone https://github.com/jacksonliam/mjpg-streamer.git
	cd mjpg-streamer/mjpg-streamer-experimental/
	make
	make install

	# Remove boot cronjob
	rm /etc/cron.d/octoprint-install
	echo "@reboot root /root/octoprint-ua-netinst.sh run >> /var/log/octoprint-ua-netinst.log 2>&1" > /etc/cron.d/octoprint-run

	echo "Finished all the stuff."
	
	# echo "Starting mjpg-streamer"
	# screen -dmS mjpg-streamer mjpg_streamer -o "output_http.so" -i "input_raspicam.so -x 1280 -y 720 -fps 1 -usestills"
fi

if [ $1 = 'help' ]; then
	echo "Help!"
fi
