import sys
from math import sin, cos, sqrt, atan2, radians
import json
import subprocess
sdtfile1= sys.argv[1]
sdtfile2= sys.argv[2]
print sdtfile1
print sdtfile2
# approximate radius of earth in km
file1='/sensorsApp/gpsdata/'+sdtfile1
file2='/sensorsApp/gpsdata/'+sdtfile2
#print file1
#print file2 
with open(file1) as fp:
    #for item in fp:
    data=json.load(fp)
    latitude1= data["Latitude"]
    longitude1 = data["Longitude"]
    startDateTime = data["GeneratedOn"]
a,b=startDateTime.split(' ')
c,d=b.split('.')
startTime=str(a)+'_'+str(c)
print startTime
#    print latitude1
#    print longitude1

with open(file2) as fp:
    #for item in fp:
    data=json.load(fp)
    latitude2= data["Latitude"]
    longitude2 = data["Longitude"]
    endDateTime = data["GeneratedOn"]
a,b=endDateTime.split(' ')
c,d=b.split('.')
endTime=str(a)+'_'+str(c)
print endTime
#    print latitude2
#    print longitude2

R = 6373.0
#lat1 = radians(28.466993666666667)
#lon1 = radians(77.08052233333333)
#lat2 = radians(28.4671175)
#lon2 = radians(77.08063333333334)
lat1 = radians(latitude1)
lon1 = radians(longitude2)
lat2 = radians(latitude2)
lon2 = radians(longitude2)
dlon = lon2 - lon1
dlat = lat2 - lat1

a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
c = 2 * atan2(sqrt(a), sqrt(1 - a))

distance = R * c
distanceMeter= distance * 1000
print("Result:", distance)
rc = subprocess.call("/home/Aggregator/RemoveGpsFiles.sh", shell=True)
if distanceMeter <50 :
	print 'vechile are not running'
	rc = subprocess.call("/home/Aggregator/InsertVehicleIdelTime.sh" + " " + str(startTime)+" "+str(endTime), shell=True)
else: 
	print 'vechile are running .....'
