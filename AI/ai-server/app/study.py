from fastapi import APIRouter, BackgroundTasks
import requests

from app.model.image import StudyImage
from app.save_image import save_image
from app.time_detection import time_detection

# get server address
import json
with open("config.json", "r") as f:
    server = json.load(f)['server']
    server_addr = f"{server['ip']}:{server['port']}"

study_router = APIRouter(prefix="/ai")

# background function
async def study_result(data: StudyImage, response):
    # if status code is not 200, do not execute post-processing function
    if response.status_code != 200:
        return
    
    # get OCR result in json
    json_result = await time_detection(data)
    
    # post result to Backend server
    try:
        requests.post(f'{server_addr}/api/v1/certification/ai-result', json=json_result)
    except requests.exceptions.HTTPError as e:
        print("POST fail:", e)
    
# original function
@study_router.post("/study")
async def study_upload(data: StudyImage, background: BackgroundTasks):
    # Upload and save the image
    response = await save_image(data)
    
    # add background task
    background.add_task(study_result, data, response)
    
    return response