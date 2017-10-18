#! /bin/bash
Speed=$1
RPM=$2
EngineTemp=$3
aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
echo $Speed
echo $RPM
echo $aggregatorId
curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddAggregatorOBD -d '
    {
        "AggregatorId":'$aggregatorId',
        "VehicleSpeed": "'"$Speed"'" ,
        "RPM":"'"$RPM"'",
	"VehicleEngineTemp":"'"$EngineTemp"'"
    }
  ' 
