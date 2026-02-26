extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("entered")
	enabled = true
	make_current()

func _exit_tree() -> void:
	print("exited")
	enabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
