aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
camera1Id=$(cat "/home/Aggregator/APIConfig.json" | jq '.camera1')
camera2Id=$(cat "/home/Aggregator/APIConfig.json" | jq '.camera2')
camera3Id=$(cat "/home/Aggregator/APIConfig.json" | jq '.camera3')
camera4Id=$(cat "/home/Aggregator/APIConfig.json" | jq '.camera4')
IPcamera1=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera1')
IPcamera2=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera2')
IPcamera3=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera3')
IPcamera4=$(cat "/home/Aggregator/APIConfig.json" | jq '.IPcamera4')
startDateTime=`date '+%Y-%m-%d %H:%M:%S'`
startTime=$(date +"%T")
#startTime="`date +%Y/%m/%d/ %H:%M:%S`";
IPcamera1=`echo "$IPcamera1" | sed -e 's/^"//' -e 's/"$//'`
IPcamera2=`echo "$IPcamera2" | sed -e 's/^"//' -e 's/"$//'`
IPcamera3=`echo "$IPcamera3" | sed -e 's/^"//' -e 's/"$//'`
IPcamera4=`echo "$IPcamera4" | sed -e 's/^"//' -e 's/"$//'`
while true
do
	sleep 60;
	packet_loss1=$( ping -c 5 -q $IPcamera1 | grep -oP '\d+(?=% packet loss)' )
	echo $packet_loss1
	if [ $packet_loss1 -ge 95 ]
	then
		statusCamera1=0
	else
		statusCamera1=1
	fi
	packet_loss2=$( ping -c 5 -q $IPcamera2 | grep -oP '\d+(?=% packet loss)' )
	echo $packet_loss2
	if [ $packet_loss2 -ge 95 ]
	then
		statusCamera2=0
	else
		statusCamera2=1
	fi
	packet_loss3=$( ping -c 5 -q $IPcamera3 | grep -oP '\d+(?=% packet loss)' )
	echo $packet_loss3
	if [ $packet_loss3 -ge 95 ]
	then
		statusCamera3=0
	else
		statusCamera3=1
	fi
	packet_loss4=$( ping -c 5 -q $IPcamera4 | grep -oP '\d+(?=% packet loss)' )
	echo $packet_loss4
	if [ $packet_loss4 -ge 95 ]
	then
		statusCamera4=0
	else
		statusCamera4=1
	fi
		echo  $statusCamera1
                echo  $statusCamera2
                echo  $statusCamera3
                echo $statusCamera4

	if [ $statusCamera1 -eq 0 ] && [ $statusCamera2 -eq 0 ] && [ $statusCamera3 -eq 0 ] && [  $statusCamera4 -eq 0 ];
        then
		echo "ALL camera are offline"
		break
	else
		echo "Camera Online"
	fi
done
endDateTime=`date '+%Y-%m-%d %H:%M:%S'`
endTime=$(date +"%T")
#endTime="`date +%Y/%m/%d %H:%M:%S`";
echo $startTime
echo $endTime

echo $endDateTime > /home/Aggregator/DriverStopTime.txt
chmod -R 777 /home/Aggregator/DriverStopTime.txt
# Convert the times to seconds from the Epoch
SEC1=`date +%s -d ${startTime}`
SEC2=`date +%s -d ${endTime}`

# Use expr to do the math, let's say TIME1 was the start and TIME2 was the finish
DIFFSEC=`expr ${SEC2} - ${SEC1}`

echo Start ${startDateTime}
echo Finish ${endDateTime}

echo Took ${DIFFSEC} seconds.

# And use date to convert the seconds back to something more meaningful
echo Took `date +%H:%M:%S -ud @${DIFFSEC}`
runningTime=`date +%H:%M:%S -ud @${DIFFSEC}`
echo vechile runningTime =  $runningTime

curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddAggregatorRunningTime -d '
    {
        "AggregatorId":'$aggregatorId',
        "StartDateTime":"'"$startDateTime"'",
        "EndDateTime":"'"$endDateTime"'",
	 "DrivingTime":"'"$runningTime"'"
    }
   '


