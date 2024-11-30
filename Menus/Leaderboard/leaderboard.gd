extends Control

var mainMenu = "res://Menus/MainMenu/MainMenu.tscn"

var entryScene = preload("res://Menus/Leaderboard/Entry.tscn")

@onready var entryContainer = $Panel/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_leaderboard()

func _update_leaderboard():
	_clear_entries()
	for i in Globals.LEADERBOARD_NAME_ENTRIES.size():
		var entry = entryScene.instantiate()
		entry.set_username(Globals.LEADERBOARD_NAME_ENTRIES[i])
		entry.set_time(Globals.LEADERBOARD_TIME_ENTRIES[i])
		entryContainer.add_child(entry)

func _clear_entries():
	var children = entryContainer.get_children()
	for i in range(1,children.size()):
		children[i].queue_free()

func _on_back_to_menu_button_pressed():
	get_tree().change_scene_to_file(mainMenu)
