import os
from fastapi import HTTPException
import json

from paddleocr import PaddleOCR
from app.model.image import StudyImage

def exception_json(code, message, id):
    content = {
        "code": code,
        "message": message,
        "certification_id": id
    }
    return json.dumps(content, indent=4)

async def time_detection(data: StudyImage):
    # get info
    id = data.certificationId
    category = data.category
    extension = data.image.split('.')[-1]
    
    # image path
    img_dir = "app/uploads"
    img_path = f"{img_dir}/{category}_{id}.{extension}"
    
    # Check the image
    if not os.path.isfile(img_path):
        return exception_json(500, "Can't find the downloaded image", id)
    
    # Do OCR
    ocr_model = PaddleOCR(lang='en')
    ocr_result = ocr_model.ocr(img_path)[0]
    
    """ ocr_result example
        [
            [
                [[126.0, 45.0], [224.0, 68.0], [220.0, 83.0], [122.0, 60.0]], ('OFACH-700', 0.71710205078125)
            ],
            [
                [[251.0, 38.0], [361.0, 63.0], [357.0, 78.0], [248.0, 53.0]], ('7', 0.644123375415802)
            ]
        ]
    """

    # Failed to get the OCR result
    if ocr_result is None:
        return exception_json(500, "Failed to get the OCR result", id)

    # make json
    result = {}
    result['code'] = 200
    result['message'] = "OK"
    result['certification_id'] = id
    result['result'] = []
    
    for item in ocr_result:
        """ item example
            [
                [[126.0, 45.0], [224.0, 68.0], [220.0, 83.0], [122.0, 60.0]], ('OFACH-700', 0.71710205078125)
            ]
        """
        
        result['result'].append(item[1][0])
    
    return json.dumps(result, indent=4)