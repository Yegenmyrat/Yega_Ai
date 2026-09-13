class_name PauseMenu
extends Control

@onready var resume_btn: Button = $VBox/ResumeButton
@onready var save_btn: Button = $VBox/SaveButton
@onready var menu_btn: Button = $VBox/MenuButton

func _ready():
	visible = false
	if GameManager:
		GameManager.game_paused.connect(_on_game_paused)
	if resume_btn:
		resume_btn.pressed.connect(_on_resume)
	if save_btn:
		save_btn.pressed.connect(_on_save)
	if menu_btn:
		menu_btn.pressed.connect(_on_menu)

func _on_game_paused(paused: bool):
	visible = paused

func _on_resume():
	if GameManager:
		GameManager.toggle_pause()

func _on_save():
	if SaveManager:
		SaveManager.save_game()

func _on_menu():
	if GameManager and GameManager.is_paused:
		GameManager.toggle_pause()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
