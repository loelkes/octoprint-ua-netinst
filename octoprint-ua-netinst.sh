#!/bin/sh

# System setting

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

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

# Install Octoprint and some basic tools
apt-get -y update
apt-get -y install nano screen python git python-pip python-dev rpi-update
cd /root/
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint
python setup.py install

# Note: mjpeg-streamer has to be installed after rpi-update and reboot.
# Todo: Perform rpi-update as first, reboot and continue.
# Todo: load scripts from github.
# Todo: launch Octprint and mjpeg-streamer.

## Install mjpeg-streamer
# cd /root/
# apt-get -y install libjpeg8-dev cmake
# git clone https://github.com/jacksonliam/mjpg-streamer.git
# cd mjpg-streamer/mjpg-streamer-experimental/
# make
# make install

# Remove boot cronjob
rm /etc/cron.d/octoprint-install

# Perform firmware update and reboot
rpi-update
echo "Finished all the stuff. Rebooting now..."
reboot

#
# screen mjpg_streamer -o "output_http.so -w /root/mjpg-streamer/mjpg-streamer-experimental/www" -i "input_raspicam.so -x 1280 -y 720 -fps 2 -quality 100 -usestills"
