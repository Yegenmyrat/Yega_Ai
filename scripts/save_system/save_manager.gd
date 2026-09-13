extends Node

const SAVE_PATH = "user://gorogly_save.json"

var save_data: Dictionary = {
	"player_health": 100.0,
	"player_stamina": 100.0,
	"checkpoint_pos": {"x": 0.0, "y": 1.0, "z": 0.0},
	"completed_quests": [],
	"active_quests": {},
	"inventory": []
}

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			save_data = json.get_data()
			return true
	return false

func set_checkpoint(pos: Vector3):
	save_data["checkpoint_pos"] = {"x": pos.x, "y": pos.y, "z": pos.z}

func get_checkpoint() -> Vector3:
	if save_data.has("checkpoint_pos"):
		var c = save_data["checkpoint_pos"]
		if c is Dictionary and c.has("x") and c.has("y") and c.has("z"):
			return Vector3(c["x"], c["y"], c["z"])
	return Vector3(0, 1, 0)
