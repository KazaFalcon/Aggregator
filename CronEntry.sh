#!/bin/bash
camera=$(date +%Y-%m-%d)
crontab -l > $camera".text"
#echo new cron into cron fil
       echo "@reboot /usr/bin/ssh -f -N -T -R 2228:localhost:22 azureuser@13.71.122.228" >> $camera".text"
        echo "@reboot sh /home/Aggregator/sshTunneling.sh" >> $camera".text"
