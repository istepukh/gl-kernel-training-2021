#!/bin/bash

prev=$(ls /dev*)
now=$(ls /dev*)

prev_lsusb=$(lsusb)
now_lsusb=$(lsusb)

#**************runtime check**************************

function check_plugged_unplugged() 
{
		count_prev=$(echo "$prev" | wc -w)
		count_now=$(echo "$now" | wc -w)
		
		if [ $count_prev -gt $count_now ]; then
			printf "\n"
			echo -n "**** UNPLUGGED ****"
			printf "\n"
			return 0
		else
			printf "\n"    		
    		echo -n "**** PLUGGED ****"
    		printf "\n"
    		return 1
		fi
}

function check_diff_lsusb() 
{
	now_lsusb=$(lsusb)
	differ_lsusb=$(echo " ${prev_lsusb} ${now_lsusb}" | tr ' ' '\n' | sort | uniq -u)
	
	if [ -n "$differ_lsusb" ]
	then
		echo -n "lsusb --> "
     	echo $differ_lsusb
	fi
	prev_lsusb=$now_lsusb
}

function check_diff_dev() 
{
	now=$(ls /dev*)
	differ=$(echo " ${prev} ${now}" | tr ' ' '\n' | sort | uniq -u)
	
	if [ -n "$differ" ]
	then
		check_plugged_unplugged
		check_pl_un=$?
		
     	differ_with_dev=$(printf "/dev/%s " $differ)
     	echo $differ_with_dev
     	check_diff_lsusb
	fi
	prev=$now
}

echo "Script will show plugged and unplugged devices. Press CTRL+C for exit."

while true
do
check_diff_dev
sleep 1
done
