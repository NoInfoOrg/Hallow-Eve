extends CanvasLayer

@onready var P1_Sanity: TextureProgressBar = $"P1/P1 Sanity"
@onready var P1_Scroll: HScrollBar = $"Sanity Test/P1 Scroll Bar"
@onready var P1_Prog: ProgressBar = $"Sanity Test/P1 Progress Bar"

@onready var P2_Sanity: TextureProgressBar = $"P2/P2 Sanity"
@onready var P2_Scroll: HScrollBar = $"Sanity Test/P2 Scroll Bar"
@onready var P2_Prog: ProgressBar = $"Sanity Test/P2 Progress Bar"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	P1_Prog.value = P1_Scroll.value
	P1_Sanity.value = P1_Prog.value
	
	P2_Prog.value = P2_Scroll.value
	P2_Sanity.value = P2_Prog.value
	
