import re
import os

def get_damage():
    with open("functions/main.gd", "r") as f:
        content = f.read()
        match = re.search(r"var damage = (\d+)", content)
        if match:
            return int(match.group(1))
    return -1

def run_script(script_name):
    os.system(f"python {script_name}")

def test_damage_cheat():
    # 1. Get initial damage
    initial_damage = get_damage()
    print(f"Initial damage: {initial_damage}")

    # 2. Run increase_damage.py
    run_script("increase_damage.py")
    increased_damage = get_damage()
    print(f"Damage after increase: {increased_damage}")
    assert increased_damage == 100, f"Expected damage to be 100, but got {increased_damage}"

    # 3. Run decrease_damage.py
    run_script("decrease_damage.py")
    decreased_damage = get_damage()
    print(f"Damage after decrease: {decreased_damage}")
    assert decreased_damage == 50, f"Expected damage to be 50, but got {decreased_damage}"
    
    # 4. Restore initial damage
    if initial_damage != 50:
        with open("functions/main.gd", "r") as f:
            content = f.read()
        new_content, count = re.subn(r"var damage = \d+(\.\d+)?", f"var damage = {initial_damage}", content)
        if count > 0:
            with open("functions/main.gd", "w") as f:
                f.write(new_content)
        print(f"Restored initial damage to {initial_damage}")

    print("Test passed!")

if __name__ == "__main__":
    test_damage_cheat()
