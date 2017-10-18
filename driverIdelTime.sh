#!/bin/bash
aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
filepath='/home/Aggregator/DriverStopTime.txt'
LINE=$(head -n 1 $filepath)
for word in $LINE;
do
	b=$word;
done
echo sandeep start_time $b;
startDateTime=$LINE
startTime=$b
endDateTime=`date '+%Y-%m-%d %H:%M:%S'`
endTime=$(date +"%T")
echo start_time  $startTime
echo end_time  $endTime
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
idelTime=`date +%H:%M:%S -ud @${DIFFSEC}`
echo vechile idelTime =  $idelTime
sleep 60
curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddAggregatorParkingTime -d '
    {
        "AggregatorId":'$aggregatorId',
        "StartDateTime":"'"$startDateTime"'",
        "EndDateTime":"'"$endDateTime"'",
        "DrivingTime":"'"$idelTime"'"
    }
   '


