# INFO Source: https://www.youtube.com/watch?v=aaFDnnrTSGg

extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $label

var currentContent = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_LineEdit_text_entered(new_text):
	#print(new_text)
	currentContent = new_text
