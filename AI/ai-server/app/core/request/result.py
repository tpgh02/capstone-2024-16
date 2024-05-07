import requests
from app.utils import SERVER_ADDR

# background function
def request_result(result, cat):
    # post result to Backend server
    try:
        r = requests.post(f'{SERVER_ADDR}/api/v1/certification/ai-result', json=result)
        print(f"[{cat} POST Response]")
        print("status code: ", r.status_code)
        print("message: ", r.text)
    except Exception as e:
        print("POST fail:", e)