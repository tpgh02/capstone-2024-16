import requests
import json

# background function
def request_result(result, cat):
    # get server address
    with open("config.json", "r") as f:
        server = json.load(f)['server']
        server_addr = f"{server['ip']}:{server['port']}"

    # post result to Backend server
    try:
        r = requests.post(f'{server_addr}/api/v1/certification/ai-result', json=result)
        print(f"[{cat} POST Response]")
        print("status code: ", r.status_code)
        print("message: ", r.text)
    except Exception as e:
        print("POST fail:", e)