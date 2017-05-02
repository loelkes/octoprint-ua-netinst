# raspbian-ua-netinst-scripts

## Goals ##
I needed a quick way to flash and install many RPis without the whole package of Raspbian. This is to be used together with [raspbian-ua-netinst](https://github.com/debian-pi/raspbian-ua-netinst).

The installer works completly unanttended.

## Howto
### Install
1. Get [raspbian-ua-netinst](https://github.com/debian-pi/raspbian-ua-netinst) on your SD Card
2. Add the files from this repository. If you already have a custom post-install.txt you can just merge them.
3. Remove comments from the software you want to install in post-install.txt
4. Reboot and wait about 30min. You can go do something more important.
### Reinstall
`cp /boot/config-reinstall.txt /boot/config.txt`. This is from [raspbian-ua-netinst](https://github.com/debian-pi/raspbian-ua-netinst)

## What does it do?
2. Install and run rpi-update, reboot
3. Install some packages (see the script for more information)

## Misc
* Everything runs as root.
