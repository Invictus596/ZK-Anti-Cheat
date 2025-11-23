extends CharacterBody3D

@onready var http := $HTTPRequest
var server_url := "http://127.0.0.1:8000/send"

func _physics_process(delta):
	# Example movement logic (your real code may be different)
	var speed = velocity.length()

	# Send movement packet every frame (or every X ms)
	send_movement_data(speed)


func send_movement_data(speed):
	var data = {
		"player": "0xGODOT_PLAYER_1",
		"type": "movement",
		"speed": speed
	}

	var json_data = JSON.stringify(data)
	http.request(server_url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_data)


func send_damage(amount):
	var data = {
		"player": "0xGODOT_PLAYER_1",
		"type": "damage",
		"damage": amount
	}
	
	var json_data = JSON.stringify(data)
	http.request(server_url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json_data)
