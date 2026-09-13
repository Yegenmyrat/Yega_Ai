class_name Player
extends CharacterBody3D

signal stats_changed(health, max_health, stamina, max_stamina)
signal attack_performed

@export var max_health: float = 100.0
@export var health: float = 100.0
@export var max_stamina: float = 100.0
@export var stamina: float = 100.0
@export var stamina_regen_rate: float = 15.0

@export var walk_speed: float = 4.0
@export var run_speed: float = 7.5
@export var jump_velocity: float = 6.0
@export var dodge_speed: float = 12.0

@onready var camera_pivot: CameraController = $CameraPivot
@onready var attack_area: Area3D = $AttackArea
@onready var mesh: MeshInstance3D = $MeshInstance3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var is_blocking: bool = false
var is_dodging: bool = false
var is_attacking: bool = false
var is_sprinting: bool = false
var is_mounted: bool = false
var mounted_horse = null

var dodge_timer: float = 0.0
var attack_timer: float = 0.0
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	if GameManager:
		GameManager.register_player(self)
	emit_signal("stats_changed", health, max_health, stamina, max_stamina)

func _physics_process(delta: float):
	if is_mounted and mounted_horse:
		mounted_horse.set_input_vector(input_vector)
		mounted_horse.set_galloping(is_sprinting)
		return

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Stamina regeneration
	if not is_sprinting and stamina < max_stamina:
		stamina = min(max_stamina, stamina + stamina_regen_rate * delta)
		emit_signal("stats_changed", health, max_health, stamina, max_stamina)

	# Handle Dodge timer
	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			is_dodging = false

	# Handle Attack timer
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

	if not is_dodging and not is_attacking:
		var cam_forward = Vector3.FORWARD
		var cam_right = Vector3.RIGHT
		if camera_pivot:
			cam_forward = camera_pivot.get_camera_forward()
			cam_right = camera_pivot.get_camera_right()

		var move_dir = (cam_forward * -input_vector.y + cam_right * input_vector.x).normalized()
		var current_speed = run_speed if (is_sprinting and stamina > 5.0 and move_dir != Vector3.ZERO) else walk_speed

		if is_sprinting and stamina > 0 and move_dir != Vector3.ZERO:
			stamina = max(0.0, stamina - 20.0 * delta)
			emit_signal("stats_changed", health, max_health, stamina, max_stamina)

		if move_dir != Vector3.ZERO:
			velocity.x = move_dir.x * current_speed
			velocity.z = move_dir.z * current_speed
			var target_angle = atan2(-move_dir.x, -move_dir.z)
			rotation.y = lerp_angle(rotation.y, target_angle, 10.0 * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func set_input_vector(p_input: Vector2):
	input_vector = p_input

func perform_jump():
	if is_mounted and mounted_horse:
		mounted_horse.perform_jump()
		return
	if is_on_floor() and stamina >= 10.0 and not is_mounted:
		velocity.y = jump_velocity
		stamina -= 10.0
		emit_signal("stats_changed", health, max_health, stamina, max_stamina)

func perform_dodge():
	if is_on_floor() and stamina >= 20.0 and not is_dodging and not is_mounted:
		is_dodging = true
		dodge_timer = 0.4
		stamina -= 20.0
		var move_dir = transform.basis.z * dodge_speed
		velocity.x = move_dir.x
		velocity.z = move_dir.z
		emit_signal("stats_changed", health, max_health, stamina, max_stamina)

func perform_attack():
	if not is_attacking and stamina >= 15.0 and not is_mounted:
		is_attacking = true
		attack_timer = 0.5
		stamina -= 15.0
		emit_signal("stats_changed", health, max_health, stamina, max_stamina)
		emit_signal("attack_performed")

		# Deal damage to enemies in attack area
		if attack_area:
			for body in attack_area.get_overlapping_bodies():
				if body.has_method("take_damage") and body != self:
					body.take_damage(25.0, global_position)

func set_blocking(p_blocking: bool):
	is_blocking = p_blocking

func set_sprinting(p_sprinting: bool):
	is_sprinting = p_sprinting

func take_damage(amount: float, _attacker_pos: Vector3 = Vector3.ZERO):
	if is_dodging:
		return

	if is_blocking:
		amount *= 0.2
		stamina = max(0.0, stamina - 15.0)

	health = max(0.0, health - amount)
	emit_signal("stats_changed", health, max_health, stamina, max_stamina)

	if health <= 0:
		die()

func die():
	# Respawn at save checkpoint
	if SaveManager:
		global_position = SaveManager.get_checkpoint()
		health = max_health
		stamina = max_stamina
		emit_signal("stats_changed", health, max_health, stamina, max_stamina)

func interact():
	if is_mounted and mounted_horse:
		mounted_horse.dismount_horse()
		return

	# Find nearby interactables (e.g. horse, NPCs, checkpoints)
	var space = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = 3.0
	query.shape = sphere
	query.transform = global_transform

	var results = space.intersect_shape(query)
	for res in results:
		var collider = res.collider
		if collider.has_method("on_player_interact"):
			collider.on_player_interact(self)
			break
