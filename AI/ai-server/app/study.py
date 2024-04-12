from fastapi import APIRouter

from app.save_image import save_image
from app.model.image import StudyImage


study_router = APIRouter(prefix="/ai/study")

@study_router.post("/upload")
def study_upload(data: StudyImage):
    # Upload and save the image
    response = save_image(data)
    return response