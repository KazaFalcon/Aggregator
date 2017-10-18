#!/bin/bash
#aggregatorId=$1
aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
while true
do
status=1
curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddOrUpdateAggregatorStatus -d '
    {
        "AggregatorId":'$aggregatorId',
         "status":"'"$status"'"
    }
   '
sleep 10;
done
