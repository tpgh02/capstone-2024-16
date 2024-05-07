from app.schemas.image import ImageData
from ultralytics import YOLO
from app.utils import exception_dict
from app.utils import LOGGER


async def gym_detection(image, data: ImageData):
    # get info
    cid = data.certificationId
    category = data.category
    
    # Check the image
    if image is None:
        LOGGER.error(f"[{category}] Can't find the downloaded image. ID: {cid}")
        return exception_dict(code=500, message="Can't find the downloaded image", cat=category, id=cid)
    
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

    res = []
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
            res.append(item['name'])
        LOGGER.debug(f"class: {item['name']}, box: {item['box']}, confidence: {item['confidence']}")
    
    # Failed to get the OCR result
    if len(res) == 0:
        LOGGER.warning(f"[{category}] Failed to get the gym detection result. ID: {cid}")
        return exception_dict(code=500, message="Failed to get the gym detection result", cat=category, id=cid)
    
    # make json
    result = {}
    result['code'] = 200
    result['message'] = "OK"
    result['category'] = category
    result['certification_id'] = cid
    result['result'] = res
    
    LOGGER.info(f"[{category}] Success gym detection. ID: {cid}, result: {res}")
    return result