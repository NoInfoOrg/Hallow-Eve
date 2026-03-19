extends Node2D

# INFO Source: https://www.youtube.com/watch?v=VqyxnKuAUH8
@onready var light_ray = $RayCast2D
@onready var label = $Label
@onready var line_2d = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_line(line_2d, light_ray.position, light_ray.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:	
	if light_ray.is_colliding():
		var collider = light_ray.get_collider()
		var collision_point = light_ray.get_collision_point()
		var local_collision_point = to_local(collision_point)
		
		#print(collider)
		#print(collision_point)
		#print(local_collision_point)
		
		#if light_ray.target_position != local_collision_point or not collider.is_in_group("Mirrors"):
		#if not collider.is_in_group("Mirrors"):
			#print(1)
			##light_ray.target_position = local_collision_point
			#reinitialize_line(local_collision_point)
			#return
		
		reinitialize_line(local_collision_point)
		
		var direction = light_ray.target_position.normalized()
		var normal = light_ray.get_collision_normal()
		
		#print(direction)
		#print(normal)
		
		var new_reflecting_sun_light_ray_scene = load("res://scenes/reflecting_sun_light_ray.tscn")
		var instance = new_reflecting_sun_light_ray_scene.instantiate()
		
		var new_light_ray = instance.get_node("RayCast2D")
		var new_line_2d = instance.get_node("Line2D")
		
		#print(line_2d)
		#print(new_line_2d)
		
		new_light_ray.position = collision_point
		new_light_ray.target_position = Vector2(collision_point[0] * normal[0], collision_point[1] * normal[1])
		
		print(new_light_ray.position)
		print(new_light_ray.target_position)
		
		new_light_ray.force_raycast_update()
		instance.initialize_line(new_line_2d, collision_point, Vector2(collision_point[0] * normal[0], collision_point[1] * normal[1]))
		
		line_2d.default_color = Color.RED
	else:
		line_2d.default_color = Color.GREEN

func initialize_line(line, point_1, point_2):
	line.points.clear()
	line.show()
	line.add_point(point_1)
	line.add_point(point_2)

func reinitialize_line(new_target_position):
	line_2d.remove_point(line_2d.points.size() - 1)
	line_2d.add_point(new_target_position)
	#line_2d.add_point(light_ray.target_position)
