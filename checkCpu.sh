#!/bin/bash
aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
while true
do
checkdiagnostics=$(cat "/home/Aggregator/APIConfig.json" | jq '.checkDiagnostics')
if [ $checkdiagnostics != 0 ];
then
	cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1""}')
	echo $cpu
	Ram=$(free -m | awk 'NR==2{printf "%d",$3*100/$2 }')
	echo $Ram
	DiskUsage=$(df -h | awk '$NF=="/"{printf "%s\n",$5}')
	echo $DiskUsage
	number=${DiskUsage%\%}
	echo $number
	now=$(date)
	echo $now
	echo $aggregatorId
	curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AggregatorDiagnostic -d '
		{
		'AggregatorId':'$aggregatorId',
		'CpuUsage':"'"$cpu"'",
		'RamUsage':"'"$Ram"'",
		'DiskUsage':"'"$number"'",
		'SentDate':"'"$now"'"
		}
		'
fi
sleep 120
done
