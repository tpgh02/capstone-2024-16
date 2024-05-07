import json


def exception_dict(code, message, cat, id):
    content = {
        "code": code,
        "message": message,
        "category": cat,
        "certification_id": id
    }
    
    return content



def get_server_address(path="config.json"):
    with open(path, "r") as f:
        conf = json.load(f)['server']
    
    if 'ip' in conf.keys() and 'port' in conf.keys():
        ip = conf['ip']
        port = conf['port']
    else:
        raise Exception("Need Server ip and port")
    
    addr = f"http://{ip}:{port}"
    return addr

SERVER_ADDR = get_server_address("config.json")