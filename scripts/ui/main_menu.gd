class_name MainMenu
extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready():
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/world/world_3d.tscn")

func _on_continue_pressed():
	if SaveManager and SaveManager.load_game():
		get_tree().change_scene_to_file("res://scenes/world/world_3d.tscn")
	else:
		_on_start_pressed()

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/settings_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
