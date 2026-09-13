class_name Checkpoint
extends Area3D

signal checkpoint_activated(checkpoint)

@export var checkpoint_id: String = "checkpoint_1"

@onready var mesh: MeshInstance3D = $MeshInstance3D

var is_activated: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if body is Player and not is_activated:
		is_activated = true
		if SaveManager:
			SaveManager.set_checkpoint(global_position)
			SaveManager.save_game()
		emit_signal("checkpoint_activated", self)

		if mesh:
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.2, 0.9, 0.3, 1) # Green active checkpoint
			mesh.material_override = mat
