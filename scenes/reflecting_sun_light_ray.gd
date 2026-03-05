extends Node2D

# INFO Source: https://www.youtube.com/watch?v=VqyxnKuAUH8
@onready var light_ray = $RayCast2D
@onready var label = $Label
@onready var line_2d = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.points.clear()
	line_2d.show()
	line_2d.add_point(light_ray.position)
	line_2d.add_point(light_ray.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if light_ray.is_colliding():
		var collider = light_ray.get_collider()
		var collision_point = light_ray.get_collision_point()
		var local_collision_point = to_local(collision_point)
		
		line_2d.default_color = Color.RED
	else:
		line_2d.default_color = Color.GREEN
