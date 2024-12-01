extends Node

@onready var pauseMenu = $"PauseMenu"
@onready var restartButton = $"PauseMenu/VBoxContainer/RestartButton"
@onready var resumeButton = $"PauseMenu/VBoxContainer/ResumeButton"
@onready var menuButton = $"PauseMenu/VBoxContainer/MainMenuButton"

@export var mouseModeOnPause: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

@export var mouseModeOnResume: Input.MouseMode = Input.MOUSE_MODE_CAPTURED

func _ready():
	resumeButton.pressed.connect(_onResumeButtonPressed)
	menuButton.pressed.connect(_onBackToMenuButtonPressed)
	restartButton.pressed.connect(_onRestartButtonPressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self._handlePauseInput()

func _handlePauseInput():
	if(Input.is_action_just_pressed("pause")):
		if(Main.getCurrentGameMode() == Main.GAME_MODE.IN_LEVEL_LOST || Main.getCurrentGameMode() == Main.GAME_MODE.IN_LEVEL_WIN):
			return
		
		var paused = get_node("/root").get_child(0).get_tree().paused
		pauseMenu.visible = !paused
		if pauseMenu.visible:
			Input.set_mouse_mode(mouseModeOnPause)
		else:
			Input.set_mouse_mode(mouseModeOnResume)
		get_node("/root").get_child(0).get_tree().paused = !paused
		Main.setInLevelPauseGameMode(paused)

func _onResumeButtonPressed():
	get_node("/root").get_child(0).get_tree().paused = false
	Input.set_mouse_mode(mouseModeOnResume)
	pauseMenu.visible = false

func _onRestartButtonPressed():
	get_owner().restart_level()
	_onResumeButtonPressed()

func _onBackToMenuButtonPressed():
	get_node("/root").get_child(0).get_tree().paused = false
	Input.set_mouse_mode(mouseModeOnResume)
	pauseMenu.visible = false
	get_tree().change_scene_to_file("res://Menus/MainMenu/MainMenu.tscn")
