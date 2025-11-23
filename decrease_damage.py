import re

# The path to the main script
main_script_path = "functions/main.gd"

# The default damage value
default_damage = 50

try:
    with open(main_script_path, "r") as f:
        content = f.read()

    # Use regex to find and replace the damage variable
    new_content, count = re.subn(r"var damage = \d+(\.\d+)?", f"var damage = {default_damage}", content)

    if count > 0:
        with open(main_script_path, "w") as f:
            f.write(new_content)
        print(f"Cheat deactivated. Bullet damage reset to {default_damage}.")
        print("Please restart the game for the change to take effect.")
    else:
        print("Could not find 'var damage = ...' in functions/main.gd.")

except FileNotFoundError:
    print(f"Error: {main_script_path} not found.")

input("Press Enter to exit...")
