#!/bin/bash
startDate_Time=$1
endDate_Time=$2
startDateTime="${startDate_Time/_/ }"
endDateTime="${endDate_Time/_/ }"
for word in $startDateTime;
do
        b=$word;
done
startTime=$b

for word1 in $endDateTime;
do
        c=$word1;
done
endTime=$c

aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
IPcamera1=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera1')
IPcamera2=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera2')
IPcamera3=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera3')
IPcamera4=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera4')
IPcamera1=`echo "$IPcamera1" | sed -e 's/^"//' -e 's/"$//'`
IPcamera2=`echo "$IPcamera2" | sed -e 's/^"//' -e 's/"$//'`
IPcamera3=`echo "$IPcamera3" | sed -e 's/^"//' -e 's/"$//'`
IPcamera4=`echo "$IPcamera4" | sed -e 's/^"//' -e 's/"$//'`
        packet_loss1=$( ping -c 5 -q $IPcamera1 | grep -oP '\d+(?=% packet loss)' )
        if [ $packet_loss1 -ge 95 ]
        then
                statusCamera1=0
        else
                statusCamera1=1
        fi
        packet_loss2=$( ping -c 5 -q $IPcamera2 | grep -oP '\d+(?=% packet loss)' )
        if [ $packet_loss2 -ge 95 ]
        then
                statusCamera2=0
        else
                statusCamera2=1
        fi
        packet_loss3=$( ping -c 5 -q $IPcamera3 | grep -oP '\d+(?=% packet loss)' )
        if [ $packet_loss3 -ge 95 ]
	then
                statusCamera3=0
        else
                statusCamera3=1
        fi
        packet_loss4=$( ping -c 5 -q $IPcamera4 | grep -oP '\d+(?=% packet loss)' )
        if [ $packet_loss4 -ge 95 ]
        then
                statusCamera4=0
        else
                statusCamera4=1
        fi

echo $startDateTime
echo $endDateTime
echo Start_time = $startTime
echo End_time = $endTime
# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${startTime}`
SEC2=`date +%s -d ${endTime}`
# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`
# And use date to convert the seconds back to something more meaningful
standingTime=`date +%H:%M:%S -ud @${DIFFSEC}`
echo vechile standingTime =  $standingTime

if [ $statusCamera1 -eq 0 ] && [ $statusCamera2 -eq 0 ] && [ $statusCamera3 -eq 0 ] && [  $statusCamera4 -eq 0 ];
then
	echo "ALL camera are offline"
else
	curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddAggregatorStandingTime -d '
    	{
        	"AggregatorId":'$aggregatorId',
		"StartDateTime":"2017-09-26 14:30:15" ,
                "EndDateTime":"2017-09-26 14:32:02",
      		"DrivingTime":"'"$standingTime"'"
   	}
 	'
	echo "Camera Online"
fi

