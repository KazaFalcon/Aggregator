#!bib/bash
cd /sensorsApp/gpsdata/
startFile=$(find -name '*.sdt' | sort -V | head -1)
endFile=$(find -name '*.sdt' | sort -V | tail -1)
#echo $startFile
#echo $endFile
python /home/project/calculateDistance.py $startFile $endFile

