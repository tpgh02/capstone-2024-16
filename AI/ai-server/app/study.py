from fastapi import APIRouter
from fastapi.middleware import Middleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
import requests

from app.model.image import StudyImage
from app.save_image import save_image
from app.time_detection import time_detection


study_router = APIRouter(prefix="/ai")

# post-processing function
async def study_result(data: StudyImage, response):
    # if status code is not 200, do not execute post-processing function
    if response.status_code != 200:
        return
    
    # get OCR result in json
    json_result = await time_detection(data)
    
    # post result to Backend server
    try:
        requests.post('http://server.com/endpoint', json=json_result)
    except requests.exceptions.HTTPError as e:
        print("POST fail:", e)
    
# middleware  
middleware = [
    Middleware(TrustedHostMiddleware, allowed_hosts=["*"]), # for all hosts
    Middleware(study_result) # post-processing function
]

# original function
@study_router.post("/study", middleware=middleware) 
async def study_upload(data: StudyImage):
    # Upload and save the image
    response = await save_image(data)
    return response