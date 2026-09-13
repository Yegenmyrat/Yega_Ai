class_name Horse
extends CharacterBody3D

signal rider_mounted(rider)
signal rider_dismounted(rider)

@export var max_health: float = 200.0
@export var health: float = 200.0
@export var trot_speed: float = 8.0
@export var gallop_speed: float = 15.0
@export var jump_velocity: float = 7.0

@onready var mount_point: Node3D = $MountPoint
@onready var interaction_area: Area3D = $InteractionArea
@onready var mesh: MeshInstance3D = $MeshInstance3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var is_being_ridden: bool = false
var current_rider: CharacterBody3D = null
var is_galloping: bool = false
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("horses")

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_being_ridden and current_rider:
		# Process horse movement based on input vector
		var move_speed = gallop_speed if is_galloping else trot_speed

		# Move forward/backward relative to camera direction if rider has camera
		if input_vector != Vector2.ZERO:
			var cam_forward = Vector3.FORWARD
			var cam_right = Vector3.RIGHT
			if current_rider and current_rider.has_node("CameraPivot"):
				var cam_pivot = current_rider.get_node("CameraPivot")
				if cam_pivot.has_method("get_camera_forward"):
					cam_forward = cam_pivot.get_camera_forward()
					cam_right = cam_pivot.get_camera_right()

			var move_dir = (cam_forward * -input_vector.y + cam_right * input_vector.x).normalized()
			if move_dir != Vector3.ZERO:
				var target_angle = atan2(-move_dir.x, -move_dir.z)
				rotation.y = lerp_angle(rotation.y, target_angle, 8.0 * delta)
				velocity.x = move_dir.x * move_speed
				velocity.z = move_dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, trot_speed)
			velocity.z = move_toward(velocity.z, 0, trot_speed)

		# Ensure rider stays attached at MountPoint
		if mount_point and current_rider:
			current_rider.global_transform = mount_point.global_transform

	else:
		# Idle horse behavior
		velocity.x = move_toward(velocity.x, 0, trot_speed)
		velocity.z = move_toward(velocity.z, 0, trot_speed)

	move_and_slide()

func on_player_interact(player: CharacterBody3D):
	if not is_being_ridden:
		mount_horse(player)
	else:
		dismount_horse()

func mount_horse(player: CharacterBody3D):
	is_being_ridden = true
	current_rider = player
	player.is_mounted = true
	player.mounted_horse = self

	# Disable player collision while mounted
	if player.has_node("CollisionShape3D"):
		player.get_node("CollisionShape3D").disabled = true

	emit_signal("rider_mounted", player)

func dismount_horse():
	if not current_rider:
		return

	var rider = current_rider
	is_being_ridden = false
	current_rider = null
	rider.is_mounted = false
	rider.mounted_horse = null

	# Re-enable player collision
	if rider.has_node("CollisionShape3D"):
		rider.get_node("CollisionShape3D").disabled = false

	# Position rider beside horse
	rider.global_position = global_position + transform.basis.x * 1.5
	emit_signal("rider_dismounted", rider)

func set_input_vector(p_input: Vector2):
	input_vector = p_input

func set_galloping(p_galloping: bool):
	is_galloping = p_galloping

func perform_jump():
	if is_on_floor() and is_being_ridden:
		velocity.y = jump_velocity

func take_damage(amount: float, _attacker_pos: Vector3 = Vector3.ZERO):
	health = max(0.0, health - amount)
	if health <= 0 and is_being_ridden:
		dismount_horse()
