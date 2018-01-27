#!/bin/sh

cpufreq-set -c 0 -g performance
cpufreq-set -c 1 -g performance
cpufreq-set -c 2 -g performance
cpufreq-set -c 3 -g performance
cpufreq-set -f 1200MHz

#echo sd > "/sys/class/leds/blue\:heartbeat/trigger"
echo none > /sys/class/leds/led1/trigger
echo none > /sys/class/leds/led0/trigger

if [ -e /boot/X11DISPLAY ]
then
	echo "X11DISPLAY"
    export DISPLAY=`cat /boot/X11DISPLAY`:0

    retry="yes"
	while [ "$retry" != "no" ]
	do
		echo "launching pianoteq with display"
		/boot/Pianoteq* --prefs pianoteq.prefs 2>pianoteq-x11display.log
		#echo `cat pianoteq-x11display.log`
		if grep -Fq "No display available" pianoteq-x11display.log
		then
			echo "no X11 connection, sleeping and retrying..."
			sleep 1
		else
			echo "stopping"
			retry="no"
		fi
	done

else
	echo "no X11DISPLAY"
	echo "launching pianoteq headless"
	/boot/Pianoteq* --prefs pianoteq.prefs --headless --midi ready.mid --play 2>pianoteq-headless.log
fi

#prevent systemctl running again the script
sleep infinity
