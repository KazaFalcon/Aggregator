import os
import time
import json
import shutil
from azure.storage.blob import BlobService
import requests
data_loaded = ""
blobService = BlobService(account_name='changovideoanalytics', account_key='tI80QuwOnv282ttR9HmXLqJR0WosC6vC1rH5H2sBdbxsVjkARCHFGjpEmbnM5+AUbKGmy7t03VgP+JCyUl64CQ==')
relevant_path = "/home/project/DumpJson/"
included_extenstions = ['.json']
destination_folder = 'DumpJson2/'
subject_path = ""
def SaveLogs(exception):
    try:
        url = 'http://52.187.185.174/api/AgreegatorController/AggregatorLogs'
        data = {"aggregatorId":"a80e9380-5d72-43d1-bdd9-9d3a78e3d564" , "Typeoflog": "ImageError", "DescriptionOflog":str(exception)}
        response = requests.post(url, data=data)
        response.status_code
        response.text
    except Exception as e:
        print(e)
def progress_callback(current, total):
    print(current)
    print("===============")
    print(total)
    print("===============")
    if(current < total):
        print("unfinish")
    else:
        print("finish upload and save data into database")
        SaveToDatabase(data_loaded)
	print("removing file ")
	os.remove(subject_path)

def PutImageToBlob(JsonData):
    try:
        LocalImageLast = JsonData["LocalImageLast"]
        head, tail = os.path.split(LocalImageLast)
        blobService.put_block_blob_from_path("analyticimage", tail, LocalImageLast)
        localImagePath = JsonData["LocalImageFirst"]
        head, tail = os.path.split(localImagePath)
        blobService.put_block_blob_from_path("analyticimage", tail, localImagePath, progress_callback=progress_callback)
	print ("UPloading file")
    except Exception as e:
        print (e)
	SaveLogs(e)
    


def SaveToDatabase(JsonData):
    try:
        url = 'http://52.187.185.174/api/CameraVideoOnDemand/AddVideoOnDemand'
        data = {"AgreegatorId": JsonData["AgreegatorId"], "CameraId": JsonData["CameraId"], "end_date":JsonData["end_date"],"start_date":JsonData["start_date"],"text":JsonData["text"],"media":JsonData["media"],"EndThumbnailUrl":JsonData["EndThumbnailUrl"]}
        response = requests.post(url, data=data)
        response.status_code
        response.text
    except Exception as e:
        print(e)
    

while True:
    file_names = [fn for fn in os.listdir(relevant_path) if any(fn.endswith(ext) for ext in included_extenstions)]
    if len(file_names) == 0:
        #print('No File')
        continue
    time.sleep(1)
    for file in file_names:
        subject_path = os.path.join(relevant_path, file)
        delete_path = os.path.join(destination_folder, file)
        with open(subject_path) as data_file:
            data_loaded = json.load(data_file)
            #print(data_loaded)
	    data_file.close()
            PutImageToBlob(data_loaded)
            #shutil.move(subject_path, delete_path)
            #os.remove(subject_path)
