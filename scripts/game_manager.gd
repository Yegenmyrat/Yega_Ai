extends Node

signal game_paused(is_paused)
signal player_spawned(player)

var is_paused: bool = false
var player: CharacterBody3D = null
var current_chapter: int = 1

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	emit_signal("game_paused", is_paused)

func register_player(p_player: CharacterBody3D):
	player = p_player
	emit_signal("player_spawned", player)
