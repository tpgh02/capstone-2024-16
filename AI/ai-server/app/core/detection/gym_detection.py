import json

from app.core.custom.exception import exception_json
from app.schemas.image import ImageData
from ultralytics import YOLO


async def gym_detection(image, data: ImageData):
    # get info
    id = data.certificationId
    category = data.category
    
    # Check the image
    if image is None:
        return exception_json(code=500, message="Can't find the downloaded image", cat=category, id=id)
    
    # Get YOLO Model and detect
    model_path = "app/model/workout/best_class14_epoch300.pt"
    yolo_model = YOLO(model_path)
    yolo_result = eval(yolo_model(image)[0].tojson())
    
    """ yolo_result example
        [
            {
                "name": "treadmill",
                "class": 13,
                "confidence": 0.77249,
                "box": {
                    "x1": 50.08743,
                    "y1": 194.68811,
                    "x2": 797.51648,
                    "y2": 600.0
                }
            },
            {
                "name": "treadmill",
                "class": 13,
                "confidence": 0.33851,
                "box": {
                    "x1": 95.83481,
                    "y1": 182.32957,
                    "x2": 493.85107,
                    "y2": 600.0
                }
            },
        ]
    """

    # Failed to get the OCR result
    if yolo_result is None:
        return exception_json(code=500, message="Failed to get the gym detection result", cat=category, id=id)
    
    # make json
    result = {}
    result['code'] = 200
    result['message'] = "OK"
    result['category'] = category
    result['certification_id'] = id
    result['result'] = []
    
    for item in yolo_result:
        """ item example
            {
                "name": "treadmill",
                "class": 13,
                "confidence": 0.77249,
                "box": {
                    "x1": 50.08743,
                    "y1": 194.68811,
                    "x2": 797.51648,
                    "y2": 600.0
                }
            }
        """
        
        threshold = 0.5
        if item['confidence'] >= threshold:
            result['result'].append(item['name'])
            
    return result