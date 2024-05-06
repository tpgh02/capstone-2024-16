import os
from PIL import Image
from io import BytesIO
import urllib.request
from urllib.error import URLError
from fastapi import HTTPException, Response
import json
import numpy as np

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
        raise HTTPException(status_code=403, detail="Image Download failed")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Can't download the image")
    
    # check extension
    extension = url.split('.')[-1]
    if not extension in ['png', 'jpg', 'jpeg']:
        raise HTTPException(status_code=400, detail="The extension of the file can only be png, jpg or jpeg.")
    
    # load the image
    try:
        img = Image.open(BytesIO(image_data)).convert("RGB")
    except IOError as e:
        raise HTTPException(status_code=400, detail="The image file not opened.")
    
    # change image from PIL to Numpy array        
    img = np.array(img)
    
    return img, Response(content=json.dumps({"message": "AI detection will be processing."}, indent=4), status_code=200)