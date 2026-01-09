#import os
from fastapi import FastAPI

app = FastAPI(title="Internal Platform Demo App")

#APP_VERSION = os.getenv("APP_VERSION", "unknown")

@app.get("/")
def home():
    return {"message": "Welcome to Internal Developer Platform"}

@app.get("/health")
def health():
    return {"status": "UP"}
    
@app.get("/version")
def version():
    return {"version": "v2.0.0"}
    