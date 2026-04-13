extends Node2D

# INFO Source: https://www.youtube.com/watch?v=VqyxnKuAUH8
@onready var light_ray = $RayCast2D
@onready var label = $Label
@onready var line_2d = $Line2D

# Experimental variables, for testing for now
var reflecting_light_already_made = false
var ray_line_is_initialized = false
var collided_mirror = null
var collided_mirror_rotation = null
var test = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	check_for_collision(self)

func check_for_collision(full_light_ray_instance):
	var ray_cast = full_light_ray_instance.get_node("RayCast2D")
	var ray_line = full_light_ray_instance.get_node("Line2D")
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		var collision_point = ray_cast.get_collision_point()
		var local_collision_point = to_local(collision_point)
		
		# If the light ray has already collided with the same mirror before, we don't need to add a reflection
		if collider.is_in_group("Mirrors"):
			if test:
				collider.get_node("Back Side Collision").disabled = true
				test = false
				return
				
			if collided_mirror == null:
				collided_mirror = collider
				collided_mirror_rotation = collider.rotation_degrees
			
			if full_light_ray_instance.reflecting_light_already_made:
				if collided_mirror == collider and collided_mirror_rotation == collider.rotation_degrees:
					return
				
				# Otherwise, update collided mirror variables to the new mirror/orientation
				collided_mirror = collider
				collided_mirror_rotation = collider.rotation_degrees
				
				# At this point, we assume that the light ray is still colliding with a mirror...
				# ...it's just that the properties of the mirror changed.
				remove_subsequent_light_ray_reflections(full_light_ray_instance)
				full_light_ray_instance.reflecting_light_already_made = false
				collider.get_node("Back Side Collision").disabled = true
				return
		
		# Change the line art to show the light ray being stopped at what it is colliding with
		if not ray_line_is_initialized:
			initialize_line(line_2d, light_ray.position, local_collision_point)
			ray_line_is_initialized = true
		
		else:
			reinitialize_line(local_collision_point)
		
		# If a light ray is not colliding with a mirror, or something other than a mirror is..
		# ...blocking it, stop the light ray at the colliding collider and remove any...
		# ...reflections that were previously after
		if not collider.is_in_group("Mirrors"):
			full_light_ray_instance.reflecting_light_already_made = false
			remove_subsequent_light_ray_reflections(full_light_ray_instance)
			test = true
			return
		
		# At this point, we assume taht the collider is a mirror
		# Turn on the mirror's backside collision, so if the light ray is colliding with the...
		# ...mirror from thew back, the reflected light ray will start inside the backside...
		# ...collision and will be invalid
		# WARNING This is super experimental, double-check that this actually works
		collider.get_node("Back Side Collision").disabled = false
		
		# Make a new reflected light ray
		var direction = ray_cast.target_position.normalized()
		var normal = ray_cast.get_collision_normal()
		
		if normal == Vector2(0.0, 0.0):
			print("reflecting_sun_light_ray.gd : light ray starts inside an object")
			return
		
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
	var new_reflecting_sun_light_ray_scene = load("res://scenes/reflecting_sun_light_ray.tscn")
	var new_light_ray_instance = new_reflecting_sun_light_ray_scene.instantiate()
	
	var new_light_ray = new_light_ray_instance.get_node("RayCast2D")
	var new_line_2d = new_light_ray_instance.get_node("Line2D")
	
	var original_ray_vector = light_ray.target_position - light_ray.position
	var reflected_ray_vector = original_ray_vector - (2 * original_ray_vector.dot(normal) * normal)
	
	# I found that starting a new light ray right on top of the previous light ray's collider...
	# ...can lead to Godot thinking that the new light ray is inside the collider and give a
	# ...normal vector of (0.0, 0.0). As a result this small_offset will make a small offset...
	# ...for the starting point of the reflected ray vector so it does not start inside a collider
	var small_offset = (reflected_ray_vector.normalized() * 0.03)
	new_light_ray.position = local_collision_point + small_offset
	
	# TODO Technically I think it should be like:
	# (reflected_ray_vector - light_ray.target_position).normalized() * a big amount
	# but otherwise it works for now, so we can change it if we need to
	new_light_ray.target_position = reflected_ray_vector - light_ray.target_position
	
	add_child(new_light_ray_instance)
	new_light_ray.force_raycast_update()

func remove_subsequent_light_ray_reflections(starting_node):
	for child_node in starting_node.get_children():
		if child_node.name == "Reflecting Sun Light Ray":
			child_node.queue_free()
