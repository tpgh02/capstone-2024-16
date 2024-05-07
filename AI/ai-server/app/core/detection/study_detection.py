from paddleocr import PaddleOCR
from app.schemas.image import ImageData
from app.utils import exception_dict
from app.utils import LOGGER


async def study_detection(image, data: ImageData):
    # get info
    cid = data.certificationId
    category = data.category
    
    # Check the image
    if image is None:
        LOGGER.error(f"[{category}] Can't find the downloaded image. ID: {cid}")
        return exception_dict(code=500, message="Can't find the downloaded image", cat=category, id=cid)
    
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
        LOGGER.warning(f"[{category}] Failed to get the OCR result. ID: {cid}")
        return exception_dict(code=500, message="Failed to get the OCR result", cat=category, id=cid)

    # get result
    res = []
    for item in ocr_result:
        """ item example
            [
                [[126.0, 45.0], [224.0, 68.0], [220.0, 83.0], [122.0, 60.0]], ('OFACH-700', 0.71710205078125)
            ]
        """
        
        res.append(item[1][0])
        
    # make json
    result = {}
    result['code'] = 200
    result['message'] = "OK"
    result['category'] = category
    result['certification_id'] = cid
    result['result'] = res
    
    LOGGER.info(f"[{category}] Success OCR. ID: {cid}, result: {res}")
    return result