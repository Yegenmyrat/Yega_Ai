class_name CameraController
extends Node3D

@export var target: Node3D = null
@export var mouse_sensitivity: float = 0.005
@export var touch_sensitivity: float = 0.008
@export var min_pitch: float = -45.0
@export var max_pitch: float = 60.0

@onready var spring_arm: SpringArm3D = $SpringArm3D
@onready var camera: Camera3D = $SpringArm3D/Camera3D

var rotation_degrees_x: float = 0.0
var rotation_degrees_y: float = 0.0

var touch_drag_index: int = -1

func _ready():
	if spring_arm and get_parent() is CollisionObject3D:
		spring_arm.add_excluded_object(get_parent().get_rid())

func _unhandled_input(event: InputEvent):
	if event is InputEventScreenTouch:
		if event.pressed and event.position.x > get_viewport().get_visible_rect().size.x * 0.4:
			if touch_drag_index == -1:
				touch_drag_index = event.index
		elif not event.pressed and event.index == touch_drag_index:
			touch_drag_index = -1

	elif event is InputEventScreenDrag and event.index == touch_drag_index:
		rotate_camera(event.relative * touch_sensitivity)

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.x > get_viewport().get_visible_rect().size.x * 0.4:
			rotate_camera(event.relative * mouse_sensitivity * 10.0)

func rotate_camera(relative_delta: Vector2):
	rotation_degrees_y -= relative_delta.x
	rotation_degrees_x -= relative_delta.y
	rotation_degrees_x = clamp(rotation_degrees_x, min_pitch, max_pitch)

	rotation_degrees = Vector3(rotation_degrees_x, rotation_degrees_y, 0)

func _process(_delta: float):
	if target:
		global_position = target.global_position + Vector3(0, 1.5, 0)

func get_camera_forward() -> Vector3:
	if camera:
		var forward = -camera.global_transform.basis.z
		forward.y = 0
		return forward.normalized()
	return Vector3.FORWARD

func get_camera_right() -> Vector3:
	if camera:
		var right = camera.global_transform.basis.x
		right.y = 0
		return right.normalized()
	return Vector3.RIGHT
