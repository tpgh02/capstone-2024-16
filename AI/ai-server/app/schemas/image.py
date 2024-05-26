from pydantic import BaseModel

class ImageData(BaseModel):
    certificationId: int
    category: str
    image: str