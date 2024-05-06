from app.core.detection.study_detection import study_detection
from app.core.detection.gym_detection import gym_detection
from app.core.request.result import request_result


async def back_task_study(image, data):
    json_result = await study_detection(image, data)
    request_result(json_result, data.category)
    
async def back_task_gym(image, data):
    json_result = await gym_detection(image, data)
    request_result(json_result, data.category)