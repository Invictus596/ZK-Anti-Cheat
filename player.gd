extends CharacterBody3D

var SPEED := 10
const JUMP_VELOCITY := 5
const MOUSE_SENSITIVITY := 0.002

@onready var main = $"../main"
@onready var camera = $Camera3D

const MovementSender = preload("res://dojo/movement_sender.gd")
var movement_sender

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	movement_sender = MovementSender.new()
	add_child(movement_sender)


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func _physics_process(delta):
	# -------- Gravity --------
	if not is_on_floor():
		velocity.y -= gravity * delta

	# -------- Jump --------
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# -------- Shooting / Actions --------
	if Input.is_action_just_pressed("fire"):
		main.shoot()

	if Input.is_action_just_pressed("reload"):
		main.reload()

	if Input.is_action_just_pressed("ads"):
		main.ads_func()

	if Input.is_action_just_pressed("inspect"):
		main.draw()

	# -------- Movement Input --------
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# -------- REQUIRED in Godot 4 --------
	velocity = velocity

	# -------- Move Character --------
	move_and_slide()

	# -------- Send movement AFTER move_and_slide --------
	movement_sender.send_movement(global_position, velocity, delta)

	main.idle()
