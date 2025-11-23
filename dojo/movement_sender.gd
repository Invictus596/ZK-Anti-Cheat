extends Node

const DojoConfig = preload("res://dojo/dojo_config.gd")

var http: HTTPRequest
var send_timer := 0.0          # rate limiting timer
var SEND_INTERVAL := 0.1       # sends data every 0.1s (10 times per second)
var player_id := "player_1"    # customize if needed

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)


func send_movement(position: Vector3, velocity: Vector3, delta: float):
	send_timer += delta
	if send_timer < SEND_INTERVAL:
		return  # wait until interval is reached

	send_timer = 0.0

	var body := {
		"type": "movement",
		"player": player_id,
		"position": [position.x, position.y, position.z],
		"velocity": [velocity.x, velocity.y, velocity.z]
	}

	var json_body := JSON.stringify(body)

	http.request(
		DojoConfig.RELAY_URL,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		json_body
	)


func _on_request_completed(result, response_code, headers, body):
	if result != OK:
		push_warning("Movement Send Error: %s" % result)
