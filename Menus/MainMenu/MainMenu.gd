extends Control

@onready var tutorialScene = load("res://Menus/Tutorial/Tutorial.tscn")
@export var testLevel = "res://Levels/TestLevel/TestLevel.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	self._initialize()

func _initialize():
	Main.setInMainMenuMainGameMode()

func onStartButtonPressed():
	get_tree().change_scene_to_file(testLevel)
	print("start button pressed: first scene" + testLevel)	

func onTutorialButtonPressed():
	var tutorialSceneInstance = tutorialScene.instantiate()
	get_tree().current_scene.add_child(tutorialSceneInstance)
	Main.setInMainMenuTutorialGameMode()

func onQuitButtonPressed():
	get_tree().quit()
