#!/bin/bash
aggregatorId=$1
cameraId=$2
cameraIp=$3
while true
do
packet_loss=$(ping -c 5 -q $cameraIp | grep -oP '\d+(?=% packet loss)')
echo $packet_loss
if [ $packet_loss -ge 95 ]
then
status=0
else
status=1
fi
python /home/project/sendchar.py $cameraId $status
curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/CameraVideoOnDemand/AddOrUpdateCameraStatus -d '
    {
        "AggregatorId":"'"$aggregatorId"'",
        "CameraId":"'"$cameraId"'",
	"status":"'"$status"'"
    }
   '
sleep 10;
done
