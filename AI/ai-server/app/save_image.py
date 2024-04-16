import os
from PIL import Image
from io import BytesIO
import urllib.request
from urllib.error import URLError
from fastapi import HTTPException, Response
import json

async def save_image(data):
    """
        request json format
        {
            "certificationId": 1,
            "category": "STUDY",
            "image": "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png"
        }
    """
    
    # save info
    id = data.certificationId
    category = data.category
    
    # image info
    url = data.image
    extension = url.split('.')[-1]
    
    # download the image
    try:
        image_data = urllib.request.urlopen(url).read()
    except URLError as e:
        raise HTTPException(status_code=403, detail="Image Download failed")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Can't download the image")
    
    # check extension
    if not extension in ['png', 'jpg', 'jpeg']:
        raise HTTPException(status_code=400, detail="The extension of the file can only be png, jpg or jpeg.")
    
    # check the uploaded folder or make
    img_dir = "app/uploads"
    os.makedirs(img_dir, exist_ok=True)
    
    # load the image
    try:
        img = Image.open(BytesIO(image_data))
    except IOError as e:
        raise HTTPException(status_code=400, detail="The image file not opened.")
        
    # save the image
    filename = f"{category}_{id}.{extension}"
    file_path = f"{img_dir}/{filename}"
    img.save(file_path, extension)
    
    return Response(content=json.dumps({"message": "OCR will be processing."}, indent=4), status_code=200)