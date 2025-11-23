import re

# The path to the player script
player_script_path = "player.gd"

# The default speed value
default_speed = 10

try:
    with open(player_script_path, "r") as f:
        content = f.read()

    # Use regex to find and replace the SPEED variable
    new_content, count = re.subn(r"var SPEED = \d+(\.\d+)?", f"var SPEED = {default_speed}", content)

    if count > 0:
        with open(player_script_path, "w") as f:
            f.write(new_content)
        print(f"Cheat deactivated. Player speed reset to {default_speed}.")
        print("Please restart the game for the change to take effect.")
    else:
        print("Could not find 'var SPEED = ...' in player.gd.")

except FileNotFoundError:
    print(f"Error: {player_script_path} not found.")

input("Press Enter to exit...")
