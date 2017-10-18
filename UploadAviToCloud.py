import sys;
import os;
import time
import shutil;
from os import path
from datetime import datetime, timedelta
import subprocess
from azure.storage.blob import BlobService
import requests
import logging
aggregatorId=sys.argv[1]
cameraId=sys.argv[2]
globtime=0
time.sleep(15)
blobService = BlobService(account_name='changovideoanalytics', account_key='tI80QuwOnv282ttR9HmXLqJR0WosC6vC1rH5H2sBdbxsVjkARCHFGjpEmbnM5+AUbKGmy7t03VgP+JCyUl64CQ==')
containerName="avi"
parent='/home/Videos/'+aggregatorId+'/'+cameraId+'/Hybrid'
directory='/home/Videos/'+aggregatorId+'/'+cameraId+'/Hybrid'
newfolder='/home/UploadedVideos'
def SaveLogs(exception):
    try:
        url = 'http://52.187.185.174/api/AgreegatorController/AggregatorLogs'
        data = {"aggregatorId":"a80e9380-5d72-43d1-bdd9-9d3a78e3d564" , "Typeoflog": "ImageError", "DescriptionOflog":str(exception)}
        response = requests.post(url, data=data)
        response.status_code
        response.text
    except Exception as e:
        print(e)
while True:
	for filename in os.listdir(parent):
    		if filename.startswith("up_"): 
			oldfile=parent+"/"+filename
			x,file=filename.split('_')
			print oldfile
        		newfilename=aggregatorId+"_"+cameraId+"_"+file
			newfile=parent+"/"+newfilename
			print newfile
			try:
				os.rename(oldfile, newfile)
			except:
				pass
			path=os.path.join(directory, newfilename)
			print(path)
			AggregatorId,CameraId,file=newfilename.split("_")
			print AggregatorId
			print CameraId
			print file
			try:
        			blobService.put_block_blob_from_path(containerName,newfilename,path,progress_callback=None,max_connections=2, max_retries=5, retry_wait=1.0)
        			url = blobService.make_blob_url(container_name=containerName,blob_name=newfilename)
        			url = '{0}://{1}{2}/{3}/{4}'.format("https","changovideoanalytics",".blob.core.windows.net",containerName,newfilename)
        			print (url)
		        	time.sleep(10)
        			#os.remove(path)
			except Exception as e:
        			SaveLogs(e)
				logging.exception(str(e))
        			print(e)
        			pass
			shutil.move(newfile,newfolder)
			continue
    		else:
			print "no file"
			time.sleep(2)
       	        	continue

