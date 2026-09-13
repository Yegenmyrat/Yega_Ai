class_name SettingsMenu
extends Control

@onready var back_button: Button = $VBox/BackButton
@onready var sfx_slider: HSlider = $VBox/SFXSlider
@onready var music_slider: HSlider = $VBox/MusicSlider

func _ready():
	if back_button:
		back_button.pressed.connect(_on_back)

func _on_back():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
