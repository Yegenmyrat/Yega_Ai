class_name VirtualJoystick
extends Control

signal joystick_vector_changed(vector: Vector2)

@export var max_distance: float = 100.0
@export var dead_zone: float = 10.0

@onready var base: Control = $Base
@onready var handle: Control = $Base/Handle

var is_pressed: bool = false
var touch_index: int = -1
var output_vector: Vector2 = Vector2.ZERO

func _ready():
	output_vector = Vector2.ZERO
	if handle:
		handle.position = base.size / 2.0 - handle.size / 2.0

func _gui_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed and touch_index == -1:
			touch_index = event.index
			is_pressed = true
			_update_joystick(event.position)
		elif not event.pressed and event.index == touch_index:
			_reset_joystick()

	elif event is InputEventScreenDrag and event.index == touch_index:
		_update_joystick(event.position)

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_pressed = true
				touch_index = 99
				_update_joystick(event.position)
			else:
				_reset_joystick()

	elif event is InputEventMouseMotion and is_pressed and touch_index == 99:
		_update_joystick(event.position)

func _update_joystick(input_pos: Vector2):
	var center = size / 2.0
	var offset = input_pos - center
	if offset.length() > max_distance:
		offset = offset.normalized() * max_distance

	if handle and base:
		handle.position = (base.size / 2.0) + offset - (handle.size / 2.0)

	if offset.length() < dead_zone:
		output_vector = Vector2.ZERO
	else:
		output_vector = offset / max_distance

	emit_signal("joystick_vector_changed", output_vector)

func _reset_joystick():
	is_pressed = false
	touch_index = -1
	output_vector = Vector2.ZERO
	if handle and base:
		handle.position = base.size / 2.0 - handle.size / 2.0
	emit_signal("joystick_vector_changed", Vector2.ZERO)

func get_output() -> Vector2:
	return output_vector
