extends Node
@export var mainMenu = "res://Menus/MainMenu/MainMenu.tscn"

const winText = "c'est gagner!"
const loseText = "c'est perdut :("

# Called when the node enters the scene tree for the first time.
func _ready():
	if(Main.getCurrentGameMode() == Main.GAME_MODE.IN_LEVEL_WIN): 
		self._showWinScreen()
	else: 
		self._showLoseScreen()	
	
func _showWinScreen():
	%RichTextLabel.text = winText
	
func _showLoseScreen():
	%RichTextLabel.text = loseText
	
func onReloadGameSceneButtonPressed():
	get_tree().reload_current_scene()

func onMainMenuButtonPressed():
	get_tree().change_scene_to_file(mainMenu)

func onQuitButtonPressed():
	get_tree().quit()
