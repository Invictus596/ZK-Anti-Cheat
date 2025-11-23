import requests
import time
import random

# <<< IMPORTANT >>> 
# Replace with your WSL IP
SERVER_URL = "http://172.29.151.248:8000/send"

PLAYER_ID = "windows_cheater"

def send_movement(position, velocity):
    payload = {
        "type": "movement",
        "player": PLAYER_ID,
        "position": position,
        "velocity": velocity
    }

    print("\nSending:", payload)
    try:
        r = requests.post(SERVER_URL, json=payload, timeout=2)
        print("Server Response:", r.json())
    except Exception as e:
        print("Error:", e)


def windows_speedhack():
    print("=== Running MASSIVE SpeedHack (Windows Client) ===")

    pos = [0, 0, 0]

    # Massive speedhack: move extremely fast each packet
    for step in range(1, 10):

        # Move 50 meters per packet = guaranteed detection
        pos = [0, 0, step * 50]

        # Velocity spoofing removed, but we still send small velocity
        vel = [0, 0, 0]

        send_movement(pos, vel)

        time.sleep(0.1)  # Reduce if you want more aggressive hack


if __name__ == "__main__":
    windows_speedhack()
