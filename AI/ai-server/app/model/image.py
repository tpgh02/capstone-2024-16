from pydantic import BaseModel

class StudyImage(BaseModel):
    certificationId: int
    category: str
    image: str