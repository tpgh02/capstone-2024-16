import json
import logging


def exception_dict(code, message, cat, id):
    content = {
        "code": code,
        "message": message,
        "category": cat,
        "certification_id": id
    }
    
    return content


def set_logger(console_level=logging.ERROR, file_level=logging.INFO, log_file_path=None):
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)
    
    # console handler
    console_format = "%(asctime)s %(levelname)s - %(message)s"
    console_date_format = "%H:%M:%S"
    console_handler = logging.StreamHandler()
    console_handler.setLevel(console_level)
    console_formatter = logging.Formatter(console_format, datefmt=console_date_format)
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)
    
    # file handler
    if log_file_path is not None:
        file_format = "%(asctime)s %(levelname)s - %(message)s - line %(lineno)s in %(funcName)s at %(filename)s"
        file_date_format = "%Y-%m-%d %H:%M:%S"
        file_handler = logging.FileHandler(log_file_path)
        file_handler.setLevel(file_level)
        file_formatter = logging.Formatter(file_format, datefmt=file_date_format)
        file_handler.setFormatter(file_formatter)
        logger.addHandler(file_handler)
        
    return logger
    
LOGGER = set_logger(log_file_path="ai-server.log", console_level=logging.WARNING)


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