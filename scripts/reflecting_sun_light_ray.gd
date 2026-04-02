extends Node2D

# INFO Source: https://www.youtube.com/watch?v=VqyxnKuAUH8
@onready var light_ray = $RayCast2D
@onready var label = $Label
@onready var line_2d = $Line2D

# For testing for now
var reflecting_light_already_made = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_line(line_2d, light_ray.position, light_ray.target_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if light_ray.is_colliding():
		if reflecting_light_already_made:
			return
		
		var collider = light_ray.get_collider()
		var collision_point = light_ray.get_collision_point()
		var local_collision_point = to_local(collision_point)
		
		#print(collider)
		#print(collision_point)
		#print(local_collision_point)
		
		if not collider.is_in_group("Mirrors"):
			return
		
		#if light_ray.target_position != local_collision_point or not collider.is_in_group("Mirrors"):
		#if not collider.is_in_group("Mirrors"):
			#print(1)
			##light_ray.target_position = local_collision_point
			#reinitialize_line(local_collision_point)
			#return
		
		reinitialize_line(local_collision_point)
		
		var direction = light_ray.target_position.normalized()
		var normal = light_ray.get_collision_normal()
		
		print(local_collision_point)
		print(normal)
		
		var new_reflecting_sun_light_ray_scene = load("res://scenes/reflecting_sun_light_ray.tscn")
		var new_light_ray_instance = new_reflecting_sun_light_ray_scene.instantiate()
		
		var new_light_ray = new_light_ray_instance.get_node("RayCast2D")
		var new_line_2d = new_light_ray_instance.get_node("Line2D")
		
		print(atan2(normal[1], normal[0]))
		
		var d = light_ray.target_position - light_ray.position
		var test = d - (2 * d.dot(normal) * normal)
		
		new_light_ray.position = local_collision_point
		#new_light_ray.target_position = local_collision_point * normal
		new_light_ray.target_position = test
		
		add_child(new_light_ray_instance)
		
		new_light_ray.force_raycast_update()
		new_light_ray_instance.initialize_line(new_line_2d, local_collision_point, test)
		
		reflecting_light_already_made = true
		line_2d.default_color = Color.RED
	else:
		reflecting_light_already_made = false
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
