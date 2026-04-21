extends Area2D

var players_detected = []
var boss_zone = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)
			boss_zone = true


func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)
		boss_zone = false
