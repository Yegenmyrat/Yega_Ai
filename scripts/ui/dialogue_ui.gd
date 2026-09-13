class_name DialogueUI
extends Control

signal dialogue_finished

@onready var speaker_label: Label = $Panel/VBox/SpeakerName
@onready var text_label: Label = $Panel/VBox/DialogueText
@onready var next_button: Button = $Panel/VBox/NextButton

var dialogue_lines: Array = []
var current_index: int = 0

func _ready():
	visible = false
	if next_button:
		next_button.pressed.connect(_on_next)

func start_dialogue(speaker: String, lines: Array):
	speaker_label.text = speaker
	dialogue_lines = lines
	current_index = 0
	visible = true
	_show_current_line()

func _show_current_line():
	if current_index < dialogue_lines.size():
		text_label.text = dialogue_lines[current_index]
	else:
		visible = false
		emit_signal("dialogue_finished")

func _on_next():
	current_index += 1
	_show_current_line()
