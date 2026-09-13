class_name InventoryUI
extends Control

@onready var item_list: ItemList = $Panel/VBox/ItemList
@onready var close_button: Button = $Panel/VBox/CloseButton

var items: Array = ["Turkmen Sword", "Epic Shield", "Health Potion x3", "Gyrat Saddle"]

func _ready():
	visible = false
	if close_button:
		close_button.pressed.connect(func(): visible = false)
	refresh_items()

func refresh_items():
	if item_list:
		item_list.clear()
		for item in items:
			item_list.add_item(item)

func toggle_inventory():
	visible = !visible
	if visible:
		refresh_items()
