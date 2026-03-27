extends SubViewport

@onready var sub_viewport: SubViewport = $"../../SubViewportContainer/SubViewport"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_2d = sub_viewport.world_2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
