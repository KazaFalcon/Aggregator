#!/bin/bash
camera=$(date +%Y-%m-%d)
crontab -l > $camera".text"
#echo new cron into cron fil
        echo "@reboot sh /home/Aggregator/updateSensorApiHost.sh" >> $camera".text"
