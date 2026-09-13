class_name QuestHUD
extends Control

@onready var quest_title: Label = $VBox/QuestTitle
@onready var objective_text: Label = $VBox/ObjectiveText

func _ready():
	if QuestManager:
		QuestManager.quest_started.connect(_on_quest_updated)
		QuestManager.quest_objective_updated.connect(_on_objective_updated)
		QuestManager.quest_completed.connect(_on_quest_completed)

func update_quest_info(title: String, objective: String):
	if quest_title:
		quest_title.text = "QUEST: " + title
	if objective_text:
		objective_text.text = "- " + objective

func _on_quest_updated(quest_id: String):
	if QuestManager and quest_id in QuestManager.active_quests:
		var q = QuestManager.active_quests[quest_id]
		var obj_index = q.get("progress", 0)
		var obj_text = q["objectives"][obj_index] if obj_index < q["objectives"].size() else "Completed"
		update_quest_info(q["title"], obj_text)

func _on_objective_updated(quest_id: String, objective_index: int, _is_completed: bool):
	if QuestManager and quest_id in QuestManager.active_quests:
		var q = QuestManager.active_quests[quest_id]
		var obj_text = q["objectives"][objective_index] if objective_index < q["objectives"].size() else "Completed"
		update_quest_info(q["title"], obj_text)

func _on_quest_completed(_quest_id: String):
	if quest_title:
		quest_title.text = "QUEST COMPLETED!"
	if objective_text:
		objective_text.text = ""
