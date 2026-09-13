extends Node

signal quest_started(quest_id)
signal quest_objective_updated(quest_id, objective_index, is_completed)
signal quest_completed(quest_id)

var active_quests: Dictionary = {}
var completed_quests: Array = []

var quest_database: Dictionary = {
	"chapter_1": {
		"title": "Chapter 1: The Legend Begins",
		"description": "Inspired by the epic of Görogly (Fictional gameplay narrative addition). Speak with Village Elder, mount Gyrat, and defend the fortress against enemy invaders.",
		"objectives": [
			"Speak with Village Elder",
			"Mount Gyrat",
			"Defeat 3 Enemy Invaders"
		],
		"progress": 0,
		"rewards": {"exp": 200, "coins": 100}
	}
}

func start_quest(quest_id: String):
	if quest_id in quest_database and quest_id not in active_quests and quest_id not in completed_quests:
		active_quests[quest_id] = quest_database[quest_id].duplicate(true)
		emit_signal("quest_started", quest_id)

func update_objective(quest_id: String, objective_index: int):
	if quest_id in active_quests:
		active_quests[quest_id]["progress"] = objective_index
		emit_signal("quest_objective_updated", quest_id, objective_index, true)
		if objective_index >= active_quests[quest_id]["objectives"].size():
			complete_quest(quest_id)

func complete_quest(quest_id: String):
	if quest_id in active_quests:
		active_quests.erase(quest_id)
		completed_quests.append(quest_id)
		emit_signal("quest_completed", quest_id)
