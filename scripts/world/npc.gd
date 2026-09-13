class_name NPC
extends CharacterBody3D

signal dialogue_requested(npc_name, lines)

@export var npc_name: String = "Village Elder"
@export var dialogue_lines: Array[String] = [
	"Greetings, Görogly! Legendary hero of Turkmenistan!",
	"Invaders are threatening our village outside the fortress.",
	"Mount Gyrat and clear out the enemy camp to protect our homeland!"
]

@onready var interaction_area: Area3D = $InteractionArea
@onready var mesh: MeshInstance3D = $MeshInstance3D

func on_player_interact(_player: Player):
	emit_signal("dialogue_requested", npc_name, dialogue_lines)
	if QuestManager:
		QuestManager.start_quest("chapter_1")
