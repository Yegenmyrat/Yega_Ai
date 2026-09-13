class_name QuestHUD
extends Control

@onready var quest_title: Label = $VBox/QuestTitle
@onready var objective_text: Label = $VBox/ObjectiveText

func _ready():
	if QuestManager:
		QuestManager.quest_started.connect(_on_quest_updated)
		QuestManager.quest_completed.connect(_on_quest_completed)

func update_quest_info(title: String, objective: String):
	if quest_title:
		quest_title.text = "QUEST: " + title
	if objective_text:
		objective_text.text = "- " + objective

func _on_quest_updated(_quest_id: String):
	update_quest_info("Chapter 1: The Legend Begins", "Talk to the Village Elder")

func _on_quest_completed(_quest_id: String):
	if quest_title:
		quest_title.text = "QUEST COMPLETED!"
	if objective_text:
		objective_text.text = ""
