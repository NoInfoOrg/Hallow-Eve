extends Node2D
@onready var watch_light = get_node("MovementCont/Eve - P1/watch_light")
@onready var will_ani = get_node("MovementCont/Willow - P2/AnimationPlayer")
var p1 : CharacterBody2D
var p2 : CharacterBody2D
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1 = get_node("MovementCont/Eve - P1")
	p2 = get_node("MovementCont/Willow - P2")
	p1.process_mode = Node.PROCESS_MODE_DISABLED
	p2.process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func watch_fizzles():
	watch_light.fizzle_out()
	
func watch_fizzles2():
	watch_light.fizzle_out2()

func move_player(player: CharacterBody2D, end_pos : Vector2, time : float):
	# I do not have the Wilbert animations rn but you'd play like the low health one ig
	print("Moving Wilbert to pos ", end_pos, " he is currently at ", p2.global_position)
	var tweeny = create_tween()
	tweeny.set_trans(Tween.TRANS_LINEAR)
	tweeny.tween_property(player, "global_position", end_pos, time)
	await tweeny.finished

func willow_enters_with_sura():
	await move_player(p2,Vector2(600,400), 2)
	await move_player(p1, Vector2(650, 400), .8)
	
