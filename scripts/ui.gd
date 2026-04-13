extends CanvasLayer

@onready var P1Node: Node2D = $P1
@onready var P2Node: Node2D = $P2

var P1_visible_pos
var P2_visible_pos

@onready var P1_Sanity: TextureProgressBar = $"P1/P1Sanity"
@onready var P1_Scroll: HScrollBar = $"SanityTest/P1ScrollBar"
@onready var P1_Prog: ProgressBar = $"SanityTest/P1ProgressBar"

@onready var P2_Sanity: TextureProgressBar = $"P2/P2Sanity"
@onready var P2_Scroll: HScrollBar = $"SanityTest/P2ScrollBar"
@onready var P2_Prog: ProgressBar = $"SanityTest/P2ProgressBar"

@onready var hide_timer = $HideUITimer

var ui_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	P1_visible_pos = P1Node.position
	P2_visible_pos = P2Node.position
	
	hide_timer.wait_time = 5.0
	hide_timer.timeout.connect(hide_ui)
	
	# Full sanity is like 98, like 100 doesn't really seem to change much of the sanity?
	P1_Sanity.value = 98
	P2_Sanity.value = 98
	
	P1Node.position.x = P1_visible_pos.x - 300
	P2Node.position.x = P2_visible_pos.x + 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#test_sanity_debug()
	pass

func test_sanity_debug():
	P1_Prog.value = P1_Scroll.value
	P1_Sanity.value = P1_Prog.value
	
	P2_Prog.value = P2_Scroll.value
	P2_Sanity.value = P2_Prog.value
	
func hide_ui():
	if ui_tween and ui_tween.is_running():
		ui_tween.kill()
		
	ui_tween = create_tween()
	ui_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	ui_tween.tween_property(P1Node, "position:x", P1_visible_pos.x - 300, 0.5)
	ui_tween.parallel().tween_property(P2Node, "position:x", P2_visible_pos.x + 300, 0.5)


func show_ui():
	hide_timer.start()
	if ui_tween and ui_tween.is_running():
		ui_tween.kill()
		
	ui_tween = create_tween()
	ui_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	ui_tween.tween_property(P1Node, "position:x", P1_visible_pos.x, 0.5)
	ui_tween.parallel().tween_property(P2Node, "position:x", P2_visible_pos.x, 0.5)
