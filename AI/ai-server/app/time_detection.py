import os
from fastapi import HTTPException

from paddleocr import PaddleOCR
from app.model.image import StudyImage

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
        return HTTPException(status_code=500, detail="Can't find the downloaded image")
    
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

    # make json
    result = {}
    result['certification_id'] = id
    result['category'] = category
    result['result'] = []
    
    for item in ocr_result:
        """ item example
            [
                [[126.0, 45.0], [224.0, 68.0], [220.0, 83.0], [122.0, 60.0]], ('OFACH-700', 0.71710205078125)
            ]
        """
        
        ocr_item = {}
        ocr_item['text'] = item[1][0]
        ocr_item['coordinates'] = item[0] # 4 coordinates are counterclockwise
        ocr_item['reliability'] = round(item[1][1], 3)
        result['result'].append(ocr_item)
    
    return result