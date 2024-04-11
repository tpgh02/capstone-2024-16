from flask import request, jsonify
from werkzeug.utils import secure_filename
import os

def upload():
    if 'image' in request.files:
        image = request.files['image']
        
        # check image file
        if image.filename == '':
            error_response = {
                "code": 400,
                "status": "Bad Request",
                "messeage": "The file is empty."
            }
            return jsonify(error_response), 400
        
        filename = secure_filename(image.filename) # get secure filename
        
        # check the uploaded folder or make
        img_dir = "app/uploads"
        os.makedirs(img_dir, exist_ok=True)
        
        # check image extension (only png, jpg, jpeg)
        extension = filename.split(".")[-1]
        print("image extention :", extension)
        if not extension in ['png', 'jpg', 'jpeg']:
            error_response = {
                "code": 400,
                "status": "Bad Request",
                "messeage": "The extension of the file can only be png, jpg or jpeg."
            }
            return jsonify(error_response), 400
        
        try:
            image_path = f"{img_dir}/{filename}"
            image.save(f"{img_dir}/{filename}") # save image
            return image_path, 200
            
        except Exception as e:
            error_response = {
                "code": 500,
                "status": "Internal Server Error",
                "messeage": str(e)
            }
            return jsonify(error_response), 500
    
    error_response = {
                "code": 400,
                "status": "Bad Request",
                "messeage": "Image not found."
            }
    
    return jsonify(error_response), 400