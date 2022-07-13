import uvicorn
import time

if __name__ == "__main__":
    time.sleep(5)
    uvicorn.run("app.app:app", host='0.0.0.0', port=80, log_level="info")