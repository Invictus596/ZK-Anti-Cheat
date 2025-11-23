extends Node

const DojoConfig = preload("res://dojo/dojo_config.gd")

var http: HTTPRequest
var player_id := "player_1"

# OPTIONAL: to avoid spamming server if gun fires extremely fast.
var SEND_INTERVAL := 0.0   # set to 0.05 if you want rate limit
var send_timer := 0.0

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)


func send_shot(position: Vector3, direction: Vector3, recoil: float, delta := 0.0):
	# ---- Optional rate limiting ----
	if SEND_INTERVAL > 0:
		send_timer += delta
		if send_timer < SEND_INTERVAL:
			return
		send_timer = 0.0
	# --------------------------------

	var body := {
		"type": "shot",
		"player": player_id,
		"position": [position.x, position.y, position.z],
		"direction": [direction.x, direction.y, direction.z],
		"recoil": recoil
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
		push_warning("Shot Send Error: %s" % result)
