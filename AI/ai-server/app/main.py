from fastapi import FastAPI
from app.study import study_router

app = FastAPI()

app.include_router(study_router) 

@app.get("/")
def hello():
    return "This is AI FastAPI server"