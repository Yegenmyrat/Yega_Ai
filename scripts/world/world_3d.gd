class_name GameWorld3D
extends Node3D

@onready var player: Player = $Player
@onready var gyrat: Horse = $Gyrat
@onready var village_elder: NPC = $VillageElder
@onready var dialogue_ui: DialogueUI = $UI/DialogueUI
@onready var quest_hud: QuestHUD = $UI/QuestHUD

var defeated_enemies_count: int = 0
const REQUIRED_ENEMIES_TO_DEFEAT: int = 2

func _ready():
	if village_elder and dialogue_ui:
		village_elder.dialogue_requested.connect(_on_npc_dialogue_requested)

	if gyrat:
		gyrat.rider_mounted.connect(_on_rider_mounted)

	for child in get_children():
		if child is EnemyBase:
			child.enemy_defeated.connect(_on_enemy_defeated)

	if QuestManager:
		QuestManager.start_quest("chapter_1")

	# Restore saved checkpoint position if available
	if SaveManager and player:
		var saved_pos = SaveManager.get_checkpoint()
		if saved_pos != Vector3.ZERO and saved_pos != player.global_position:
			player.global_position = saved_pos

func _on_npc_dialogue_requested(speaker_name: String, lines: Array):
	if dialogue_ui:
		dialogue_ui.start_dialogue(speaker_name, lines)
	if QuestManager:
		QuestManager.update_objective("chapter_1", 1)

func _on_rider_mounted(_rider: Player):
	if QuestManager:
		QuestManager.update_objective("chapter_1", 2)

func _on_enemy_defeated(_enemy: EnemyBase):
	defeated_enemies_count += 1
	if defeated_enemies_count >= REQUIRED_ENEMIES_TO_DEFEAT:
		if QuestManager:
			QuestManager.complete_quest("chapter_1")
