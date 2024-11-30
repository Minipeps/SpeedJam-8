extends Node
@export var mainMenu = "res://Menus/MainMenu/MainMenu.tscn"
var leaderboard = "res://Menus/Leaderboard/Leaderboard.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	$FinalTimeLabel.text = Globals.get_formulated_time_elapsed()
	
func onReloadGameSceneButtonPressed():
	get_tree().change_scene_to_file("res://2D/Level.tscn")

func onMainMenuButtonPressed():
	get_tree().change_scene_to_file(mainMenu)

func onQuitButtonPressed():
	get_tree().quit()

func onSaveButtonPressed():
	var username = $HBoxContainer/TextEdit.text
	if username == "":
		username = "Anonymous"
	Globals.add_leaderboard_entry(username, Globals.TIME_ELAPSED)

func onLeaderboardButtonPressed():
	get_tree().change_scene_to_file(leaderboard)
