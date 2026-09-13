class_name QuestResource
extends Resource

@export var quest_id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var chapter: int = 1
@export var is_fictional_gameplay_addition: bool = true
@export var objectives: Array[String] = []
@export var exp_reward: int = 100
@export var coin_reward: int = 50
