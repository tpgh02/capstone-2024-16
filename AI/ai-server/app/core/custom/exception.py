def exception_dict(code, message, cat, id):
    content = {
        "code": code,
        "message": message,
        "category": cat,
        "certification_id": id
    }
    
    return content