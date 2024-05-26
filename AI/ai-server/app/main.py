from fastapi import FastAPI
from app.routers.certification import ai_router

app = FastAPI()

app.include_router(ai_router)

@app.get("/")
def hello():
    return "This is AI FastAPI server"