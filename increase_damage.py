import re

# The path to the main script
main_script_path = "functions/main.gd"

# The new damage value
cheated_damage = 100

try:
    with open(main_script_path, "r") as f:
        content = f.read()

    # Use regex to find and replace the damage variable
    # This will match "var damage = <any number>"
    new_content, count = re.subn(r"var damage = \d+(\.\d+)?", f"var damage = {cheated_damage}", content)

    if count > 0:
        with open(main_script_path, "w") as f:
            f.write(new_content)
        print(f"Cheat activated! Bullet damage set to {cheated_damage}.")
        print("Please restart the game for the change to take effect.")
    else:
        print("Could not find 'var damage = ...' in functions/main.gd.")
        print("Please ensure functions/main.gd contains this line.")

except FileNotFoundError:
    print(f"Error: {main_script_path} not found.")

input("Press Enter to exit...")
