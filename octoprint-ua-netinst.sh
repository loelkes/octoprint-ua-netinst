#!/bin/sh

# System setting

apt-get update
apt-get -y install nano screen python git python-pip python-dev rpi-update
cd /root/
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint
python setup.py install
