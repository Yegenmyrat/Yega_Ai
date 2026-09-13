class_name EnemyBase
extends CharacterBody3D

signal enemy_defeated(enemy)

@export var max_health: float = 60.0
@export var health: float = 60.0
@export var move_speed: float = 3.5
@export var attack_damage: float = 15.0
@export var attack_range: float = 2.0
@export var detection_radius: float = 12.0

@onready var detection_area: Area3D = $DetectionArea
@onready var attack_area: Area3D = $AttackArea

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var target_player: Player = null
var attack_cooldown: float = 0.0

func _ready():
	add_to_group("enemies")

func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if attack_cooldown > 0:
		attack_cooldown -= delta

	if target_player and is_instance_valid(target_player) and health > 0:
		var dist = global_position.distance_to(target_player.global_position)
		if dist <= detection_radius:
			var dir = (target_player.global_position - global_position)
			dir.y = 0
			dir = dir.normalized()

			if dist > attack_range:
				velocity.x = dir.x * move_speed
				velocity.z = dir.z * move_speed
				var target_rot = atan2(-dir.x, -dir.z)
				rotation.y = lerp_angle(rotation.y, target_rot, 8.0 * delta)
			else:
				velocity.x = 0
				velocity.z = 0
				if attack_cooldown <= 0:
					_perform_attack()

	move_and_slide()

func _perform_attack():
	attack_cooldown = 1.5
	if target_player and is_instance_valid(target_player):
		target_player.take_damage(attack_damage, global_position)

func take_damage(amount: float, _attacker_pos: Vector3 = Vector3.ZERO):
	health -= amount
	if health <= 0:
		die()

func die():
	emit_signal("enemy_defeated", self)
	queue_free()

func _on_detection_area_body_entered(body: Node3D):
	if body is Player:
		target_player = body
