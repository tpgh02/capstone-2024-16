from fastapi import BackgroundTasks, HTTPException
from fastapi import APIRouter

from app.schemas.image import ImageData
from app.core.image.image_function import save_image
from app.core.back_function import back_task_study
from app.core.back_function import back_task_gym


# define router
ai_router = APIRouter(prefix="/ai")

# original function
@ai_router.post("/certification")
async def study(data: ImageData, background: BackgroundTasks):
    # Upload and save the image
    image, response = await save_image(data)
    
    # for test background task
    # from fastapi import Response
    # response = Response(content=json.dumps({"message": "OCR will be processing."}, indent=4), status_code=200)
    
    # add background task
    if response.status_code == 200:
        if data.category == "STUDY":
            background.add_task(back_task_study, image, data)
        elif data.category == "GYM":
            background.add_task(back_task_gym, image, data)
        else:
            raise HTTPException(status_code=400, detail="Wrong category. The category should be only STUDY and GYM")
    
    return response