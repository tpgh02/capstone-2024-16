import os
from PIL import Image
from io import BytesIO
import urllib.request
from urllib.error import URLError
from fastapi import HTTPException, Response
import json
import numpy as np

from app.utils import LOGGER


async def save_image(data):
    """
        request json format
        {
            "certificationId": 1,
            "category": "STUDY",
            "image": "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png"
        }
    """
    
    # image url
    url = data.image
    
    # download the image
    try:
        image_data = urllib.request.urlopen(url).read()
    except URLError as e:
        LOGGER.error(f"Image download failed, {e}. URL: {url}")
        raise HTTPException(status_code=403, detail="Image Download failed")
    except Exception as e:
        LOGGER.error(f"Can't download the image, {e}. URL: {url}")
        raise HTTPException(status_code=500, detail="Can't download the image")
    
    # check extension
    extension = url.split('.')[-1]
    if not extension in ['png', 'jpg', 'jpeg']:
        LOGGER.error(f"Extension error, Requested extension: {extension}")
        raise HTTPException(status_code=400, detail="The extension of the file can only be png, jpg or jpeg.")
    
    # load the image
    try:
        img = Image.open(BytesIO(image_data)).convert("RGB")
    except IOError as e:
        LOGGER.error(f"Image not opened")
        raise HTTPException(status_code=400, detail="The image file not opened.")
    
    # change image from PIL to Numpy array
    img = np.array(img)
    
    LOGGER.info(f"Success download the image. ID: {data.certificationId}, URL: {url}, image: {img.shape}")
    return img, Response(content=json.dumps({"message": "AI detection will be processing."}, indent=4), status_code=200)