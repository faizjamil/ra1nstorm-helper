#!/bin/sh
# (C) 2019 Ronsor Labs, the ra1nstorm contributors, et al.

# Fixes internationalization woes
export LANG=C
ID="$(id -u)"
if [ "$ID" != 0 ]; then
	echo "ra1nstorm must be run as root"
	which sudo 2>&1 >/dev/null && exec sudo $0
	echo "enter root password below"
	exec su -c $0
fi
echo "Checking if zenity and gawk are installed..."
# TODO: debug below code
if [ apt-get update ]; then
        echo "apt detected, packages updated"
       	which gawk 2>&1 >/dev/null || apt install -y gawk
        which zenity 2>&1 >/dev/null || apt install -y zenity
elif [ pacman -Syu ] ; then
        echo "pacman detected, packages updated"
	which gawk 2>&1 >/dev/null || pacman -Syu  --noconfirm gawk
        which zenity 2>&1 >/dev/null || pacman -Syu --noconfirm zenity
else
        echo "yum detected, updating packages"
        yum update -y
	which gawk 2>&1 >/dev/null || yum install  -y gawk
        which zenity 2>&1 >/dev/null || yum install -y zenity
fi

echo "Launching setup..."
gawk -f main.awk 2>&1 | tee -a /tmp/ra1nstorm.log
