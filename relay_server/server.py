from fastapi import FastAPI, Request
import uvicorn

app = FastAPI()

@app.post("/send")
async def receive_data(request: Request):
    data = await request.json()

    print("\n--- Incoming Data From Godot ---")
    print(data)

    # TODO: Add cheat detection here
    # TODO: Add Katana forwarding later

    return {"status": "ok", "received": data}


if __name__ == "__main__":
    uvicorn.run("server:app", host="127.0.0.1", port=8000, reload=True)
