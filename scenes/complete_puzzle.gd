extends Sprite2D

var puzzleDisplayed: bool = false

func _ready() -> void:
	hide()
	
func display_puzzle():
	if puzzleDisplayed:
		return
	else:
		puzzleDisplayed = true
		show()
