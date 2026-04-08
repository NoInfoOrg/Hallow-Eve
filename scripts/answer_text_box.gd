# INFO Source: https://www.youtube.com/watch?v=aaFDnnrTSGg

extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $label

var currentContent : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.max_length = 10
	hide()
	line_edit.text_changed.connect(on_text_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_text_input(new_text):
	#print(new_text)
	#currentContent = new_text
	# filtering the input type beat
	var res = ""
	for char in new_text:
		if char.is_valid_int():
			res += char
	line_edit.text = res
	line_edit.caret_column = res.length()
