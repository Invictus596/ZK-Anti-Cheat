extends CharacterBody3D

# --- 1. GAME SETTINGS ---
const SPEED = 10.0
const BULLET_DAMAGE = 50
const MAX_HEALTH = 100
const JUMP_VELOCITY = 5
const mouse_sensitivity = 0.002
const GRAVITY = 9.8

# --- 2. BLOCKCHAIN SETTINGS (NEW) ---
# Using the IP you confirmed earlier to avoid "Error 44"
const RELAY_URL = "http://192.168.1.102:3000/shoot" 
var http_request : HTTPRequest

# --- 3. REFERENCES ---
@onready var main = $"../main"
@onready var camera = $Camera3D

# --- 4. STATE VARIABLES ---
var health = MAX_HEALTH
var is_cheater_detected = false

# Anti-cheat tracking
var last_position: Vector3
var last_time: float

func _ready():
	# 1. Setup Gameplay
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group("player")

	# 2. Setup Anti-Cheat Tracking
	last_position = global_transform.origin
	last_time = Time.get_ticks_msec() / 1000.0
	
	# 3. Setup Network (Create the node via code so you don't have to drag anything)
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_blockchain_response)

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _physics_process(delta):
	# --- A. LOCAL ANTI-CHEAT ---
	_check_movement_speed_cheat(delta)
	
	# If cheater detected locally, stop movement
	if is_cheater_detected:
		velocity = Vector3.ZERO
		return

	# --- B. MOVEMENT PHYSICS ---
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- C. WEAPON INPUTS ---
	if Input.is_action_just_pressed("fire"):
		_check_damage_cheat() # 1. Verify integrity
		main.shoot()          # 2. Visuals (Client Side Prediction)
		_send_blockchain_tx() # 3. Verify on Chain (Async)
		
	if Input.is_action_just_pressed("reload"):
		main.reload()
	if Input.is_action_just_pressed("ads"):
		main.ads_func()
	if Input.is_action_just_pressed("inspect"):
		main.draw()
		
	# --- D. WASD MOVEMENT ---
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	main.idle()

	# --- E. CHEATER PENALTY ---
	if is_cheater_detected and health > 0:
		health = 0
		_on_player_cheater_detected()

# ---------------------------------------------------------
# --- BLOCKCHAIN LOGIC (The Backend Connection) ---
# ---------------------------------------------------------

func _send_blockchain_tx():
	# Don't send if we are already waiting for a response
	if http_request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return
		
	var headers = ["Content-Type: application/json"]
	# Sending dummy physics data (Angle 0, Recoil 5) for verification
	var body = JSON.stringify({ "angle": 0, "recoil": 5 })
	
	print("🚀 Sending proof to Katana...")
	var error = http_request.request(RELAY_URL, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("❌ Network Error: ", error)

func _on_blockchain_response(result, response_code, headers, body):
	if response_code == 200:
		print("✅ Shot Verified on Chain!")
	else:
		print("⚠️ Chain Rejected Shot (Possible Cheat/Lag): ", response_code)

# ---------------------------------------------------------
# --- EXISTING ANTI-CHEAT LOGIC (PRESERVED) ---
# ---------------------------------------------------------

func _on_player_cheater_detected():
	print("CHEATER DETECTED: Player health set to 0")

func _check_damage_cheat():
	if main.damage != BULLET_DAMAGE:
		print("CHEAT DETECTED: Damage has been modified from ", BULLET_DAMAGE, " to ", main.damage)
		is_cheater_detected = true

func _check_movement_speed_cheat(delta):
	var current_position = global_transform.origin
	var distance_moved = current_position.distance_to(last_position)
	var current_time = Time.get_ticks_msec() / 1000.0
	var time_elapsed = current_time - last_time

	if time_elapsed > 0.1:
		var actual_speed = distance_moved / time_elapsed
		if actual_speed > (SPEED * 3.0):
			print("CHEAT DETECTED: Speed limit exceeded: ", actual_speed)
			is_cheater_detected = true
			
		last_position = current_position
		last_time = current_time
