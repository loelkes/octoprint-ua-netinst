#!/bin/sh

# System setting

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [ $1 = 'firstboot' ]; then

	# Overclocking
	echo "arm_freq=1000" >> /boot/config.txt
	echo "sdram_freq=500" >> /boot/config.txt
	echo "core_freq=500" >> /boot/config.txt
	echo "over_voltage=6" >> /boot/config.txt
	echo "temp_limit=75" >> /boot/config.txt
	echo "boot_delay=" >> /boot/config.txt

	# Disable the splash screen
	echo "disable_splash=1" >> /boot/config.txt

	# Enable camera
	echo "start_x=1" >> /boot/config.txt

	apt-get -y install rpi-update
	rpi-update
	echo "@reboot root /root/setup-octoprint.sh secondboot >> /var/log/octoprint-ua-netinst.log 2>&1" > /etc/cron.d/octoprint-install
	echo "Rebooting..."
	reboot

fi

if [ $1 = 'secondboot' ]; then

	# Install Octoprint and some basic tools
	apt-get -y install nano screen python git python-pip python-dev
	cd /root/
	git clone https://github.com/foosel/OctoPrint.git
	cd OctoPrint
	python setup.py install

	## Install mjpeg-streamer
	cd /root/
	apt-get -y install libjpeg8-dev cmake
	git clone https://github.com/jacksonliam/mjpg-streamer.git
	cd mjpg-streamer/mjpg-streamer-experimental/
	make
	make install

	# Remove boot cronjob
	rm /etc/cron.d/octoprint-install

	echo "Finished all the stuff. Rebooting now..."

	screen -dmS octoprint octoprint --iknowwhatimdoing
	screen -dmS mjpg-streamer mjpg_streamer -o "output_http.so -w /root/mjpg-streamer/mjpg-streamer-experimental/www" -i "input_raspicam.so -x 1280 -y 720 -fps 2 -quality 100 -usestills"
fi

if [ $1 = 'help' ]; then
	echo "Help!"
fi
