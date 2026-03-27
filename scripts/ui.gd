extends CanvasLayer

@onready var P1_Sanity: TextureProgressBar = $"P1/P1Sanity"
@onready var P1_Scroll: HScrollBar = $"SanityTest/P1ScrollBar"
@onready var P1_Prog: ProgressBar = $"SanityTest/P1ProgressBar"

@onready var P2_Sanity: TextureProgressBar = $"P2/P2Sanity"
@onready var P2_Scroll: HScrollBar = $"SanityTest/P2ScrollBar"
@onready var P2_Prog: ProgressBar = $"SanityTest/P2ProgressBar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Full sanity is like 98, like 100 doesn't really seem to change much of the sanity?
	P1_Sanity.value = 98
	P2_Sanity.value = 98

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#test_sanity_debug()
	pass

func test_sanity_debug():
	P1_Prog.value = P1_Scroll.value
	P1_Sanity.value = P1_Prog.value
	
	P2_Prog.value = P2_Scroll.value
	P2_Sanity.value = P2_Prog.value
