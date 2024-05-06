import json

def exception_json(code, message, cat, id):
    content = {
        "code": code,
        "message": message,
        "category": cat,
        "certification_id": id
    }
    
    return json.dumps(content, indent=4)