#!/bin/sh
makoctl reload

ID=100
LIGHT='░'
DARK='▓'

full=40

if 		[[ $1 == "brightness" ]]; then
	max=$(brightnessctl m)
	cur=$(brightnessctl g)
	

	percent=$((cur*10/max*10))
	
	progress=$((cur*10/max*4))
	msg="Brightness: $percent %"
	
elif 	[[ $1 == "volume" ]]; then
	cmd="$(wpctl get-volume @DEFAULT_SINK@)"

	
	num=${cmd:8:4}
	num=$(echo "${num}" | tr -d '.')

	if [[ ${num:0:1} == '0' ]]; then
		num=${num:1}
	fi
	
	msg="Volume: $num %"

	if [[ $(echo "${cmd}" | grep "MUTED") ]]; then
		muted=true
		msg="${msg} (Muted)"
	else
		muted=false
	fi
	progress=$((num/5*2))
	
fi


for i in {1..40}
do
	if 		[[ $i -lt $progress ]]; then
		bar="${bar}▒"
	elif 	[[ $i == $progress ]]; then
		bar="${bar}█"
	else
		bar="${bar}░"
	fi
done

makoctl dismiss $ID
notify-send -c osd --id-fd=$ID -r $ID "$msg" "$bar"
