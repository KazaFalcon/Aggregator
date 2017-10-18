#! /bin/bash
DownloadSpeed=$1
UploadSpeed=$2
aggregatorId=$(cat "/home/Aggregator/APIConfig.json" | jq '.AgreegatorId')
#bandWidthstatus=$(cat "/home/Aggregator/APIConfig.json" | jq '.BandWidthStatus')
echo $DownloadSpeed
echo $UploadSpeed
echo $aggregatorId
curl -X POST -i -H "Content-type: application/json" -X POST http://52.187.185.174/api/AgreegatorController/AddAggregatorNetSpeed -d '
    {
        "AggregatorId":'$aggregatorId',
        "DownloadSpeed": "'"$DownloadSpeed"'" ,
        "UploadSpeed":"'"$UploadSpeed"'"
    }
  ' 
