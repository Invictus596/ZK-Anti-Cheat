import re

# The path to the player script
player_script_path = "player.gd"

# The new speed value
cheated_speed = 50

try:
    with open(player_script_path, "r") as f:
        content = f.read()

    # Use regex to find and replace the SPEED variable
    # This will match "var SPEED = <any number>"
    new_content, count = re.subn(r"var SPEED = \d+(\.\d+)?", f"var SPEED = {cheated_speed}", content)

    if count > 0:
        with open(player_script_path, "w") as f:
            f.write(new_content)
        print(f"Cheat activated! Player speed set to {cheated_speed}.")
        print("Please restart the game for the change to take effect.")
    else:
        print("Could not find 'var SPEED = ...' in player.gd.")
        print("Please ensure player.gd contains this line.")

except FileNotFoundError:
    print(f"Error: {player_script_path} not found.")

input("Press Enter to exit...")
