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
	check_for_collision(self)

func check_for_collision(full_light_ray_instance):
	var ray_cast = full_light_ray_instance.get_node("RayCast2D")
	var ray_line = full_light_ray_instance.get_node("Line2D")
	
	if ray_cast.is_colliding():
		if full_light_ray_instance.reflecting_light_already_made:
			return
		
		var collider = ray_cast.get_collider()
		var collision_point = ray_cast.get_collision_point()
		var local_collision_point = to_local(collision_point)
		
		# Only make a reflection if the light ray is colliding with a mirror
		if not collider.is_in_group("Mirrors"):
			#print(collider)
			return
		
		# Change the line art to show the light ray being stopped at what it is colliding with
		reinitialize_line(local_collision_point)
		
		# Make a new reflected light ray
		var direction = ray_cast.target_position.normalized()
		var normal = ray_cast.get_collision_normal()
		
		#print(local_collision_point)
		#print(normal)
		
		make_new_light_ray(local_collision_point, normal)
		
		full_light_ray_instance.reflecting_light_already_made = true
		ray_line.default_color = Color.RED
	else:
		full_light_ray_instance.reflecting_light_already_made = false
		ray_line.default_color = Color.GREEN

func initialize_line(line, point_1, point_2):
	line.points.clear()
	line.show()
	line.add_point(point_1)
	line.add_point(point_2)

func reinitialize_line(new_target_position):
	line_2d.remove_point(line_2d.points.size() - 1)
	line_2d.add_point(new_target_position)

func make_new_light_ray(local_collision_point, normal):
	print("called")
	var new_reflecting_sun_light_ray_scene = load("res://scenes/reflecting_sun_light_ray.tscn")
	var new_light_ray_instance = new_reflecting_sun_light_ray_scene.instantiate()
	
	var new_light_ray = new_light_ray_instance.get_node("RayCast2D")
	var new_line_2d = new_light_ray_instance.get_node("Line2D")
	
	var original_ray_vector = light_ray.target_position - light_ray.position
	var reflected_ray_vector = original_ray_vector - (2 * original_ray_vector.dot(normal) * normal)
	
	new_light_ray.position = local_collision_point
	new_light_ray.target_position = reflected_ray_vector - light_ray.target_position
	
	add_child(new_light_ray_instance)
	
	new_light_ray.force_raycast_update()
