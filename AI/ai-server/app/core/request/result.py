import requests
from app.utils import SERVER_ADDR
from app.utils import LOGGER

# background function
def request_result(result, data):
    # post result to Backend server
    try:
        r = requests.post(f'{SERVER_ADDR}/api/v1/certification/ai-result', json=result)
        if r.status_code == 200:
            print(r.text)
            LOGGER.info(f"[{data.category}] Success post the result. code: {r.status_code}, message: {r.text}, ID: {data.certificationId}")
        else:
            LOGGER.warning(f"[{data.category}] Success post the result. code: {r.status_code}, message: {r.text}, ID: {data.certificationId}")
        
    except Exception as e:
        LOGGER.error(f"[{data.category}] POST fail, {e}. ID: {data.certificationId}")