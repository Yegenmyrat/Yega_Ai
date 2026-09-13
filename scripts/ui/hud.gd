class_name HUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $Control/VBoxContainer/HealthBar
@onready var stamina_bar: ProgressBar = $Control/VBoxContainer/StaminaBar
@onready var health_label: Label = $Control/VBoxContainer/HealthBar/HealthLabel
@onready var stamina_label: Label = $Control/VBoxContainer/StaminaBar/StaminaLabel
@onready var interact_prompt: Label = $Control/InteractPrompt
@onready var touch_controls: TouchControls = $TouchControls

var player: Player = null

func _ready():
	if GameManager:
		GameManager.player_spawned.connect(_on_player_spawned)
		if GameManager.player:
			_on_player_spawned(GameManager.player)

	if touch_controls:
		touch_controls.attack_pressed.connect(_on_attack)
		touch_controls.block_pressed.connect(_on_block)
		touch_controls.dodge_pressed.connect(_on_dodge)
		touch_controls.jump_pressed.connect(_on_jump)
		touch_controls.interact_pressed.connect(_on_interact)
		touch_controls.sprint_toggled.connect(_on_sprint)

func _process(_delta: float):
	if player and touch_controls:
		player.set_input_vector(touch_controls.get_movement_vector())

func _on_player_spawned(p_player: Player):
	player = p_player
	player.stats_changed.connect(_on_stats_changed)
	_on_stats_changed(player.health, player.max_health, player.stamina, player.max_stamina)

func _on_stats_changed(health: float, max_health: float, stamina: float, max_stamina: float):
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
	if health_label:
		health_label.text = "HP: %d/%d" % [int(health), int(max_health)]
	if stamina_bar:
		stamina_bar.max_value = max_stamina
		stamina_bar.value = stamina
	if stamina_label:
		stamina_label.text = "STAMINA: %d/%d" % [int(stamina), int(max_stamina)]

func show_interact_prompt(text: String, prompt_visible: bool = true):
	if interact_prompt:
		interact_prompt.visible = prompt_visible
		interact_prompt.text = text

func _on_attack():
	if player:
		player.perform_attack()

func _on_block(is_blocking: bool):
	if player:
		player.set_blocking(is_blocking)

func _on_dodge():
	if player:
		player.perform_dodge()

func _on_jump():
	if player:
		player.perform_jump()

func _on_interact():
	if player:
		player.interact()

func _on_sprint(is_sprinting: bool):
	if player:
		player.set_sprinting(is_sprinting)
