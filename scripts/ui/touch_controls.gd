class_name TouchControls
extends Control

signal attack_pressed
signal block_pressed(is_blocking)
signal dodge_pressed
signal jump_pressed
signal interact_pressed
signal sprint_toggled(is_sprinting)

@onready var joystick: VirtualJoystick = $VirtualJoystick
@onready var attack_btn: Button = $ActionButtons/AttackButton
@onready var block_btn: Button = $ActionButtons/BlockButton
@onready var dodge_btn: Button = $ActionButtons/DodgeButton
@onready var jump_btn: Button = $ActionButtons/JumpButton
@onready var interact_btn: Button = $ActionButtons/InteractButton
@onready var sprint_btn: Button = $ActionButtons/SprintButton

var is_sprinting: bool = false

func _ready():
	if attack_btn:
		attack_btn.pressed.connect(func(): emit_signal("attack_pressed"))
	if block_btn:
		block_btn.button_down.connect(func(): emit_signal("block_pressed", true))
		block_btn.button_up.connect(func(): emit_signal("block_pressed", false))
	if dodge_btn:
		dodge_btn.pressed.connect(func(): emit_signal("dodge_pressed"))
	if jump_btn:
		jump_btn.pressed.connect(func(): emit_signal("jump_pressed"))
	if interact_btn:
		interact_btn.pressed.connect(func(): emit_signal("interact_pressed"))
	if sprint_btn:
		sprint_btn.pressed.connect(_on_sprint_toggled)

func _on_sprint_toggled():
	is_sprinting = !is_sprinting
	emit_signal("sprint_toggled", is_sprinting)

func get_movement_vector() -> Vector2:
	if joystick:
		return joystick.get_output()
	return Vector2.ZERO
