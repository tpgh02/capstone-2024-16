import os
from fastapi import HTTPException
import json

from paddleocr import PaddleOCR
from app.model.image import StudyImage

def exception_json(code, message, cat, id):
    content = {
        "code": code,
        "message": message,
        "category": cat,
        "certification_id": id
    }
    return json.dumps(content, indent=4)

async def time_detection(image, data: StudyImage):
    # get info
    id = data.certificationId
    category = data.category
    
    # Check the image
    if image is None:
        return exception_json(code=500, message="Can't find the downloaded image", cat=category, id=id)
    
    # Do OCR
    ocr_model = PaddleOCR(lang='en')
    ocr_result = ocr_model.ocr(image)[0]
    
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
        return exception_json(code=500, message="Failed to get the OCR result", cat=category, id=id)

    # make json
    result = {}
    result['code'] = 200
    result['message'] = "OK"
    result['category'] = category
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