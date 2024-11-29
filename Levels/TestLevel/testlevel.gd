extends Node3D

@onready var popossum:CSGBox3D  = get_node("Popossum")
@onready var pauseMenu  = load("res://Menus/PauseMenu/PauseMenu.tscn")
@onready var endScreen = load("res://Menus/EndScreen/EndScreen.tscn")

@export var speed: float = 45

# Called when the node enters the scene tree for the first time.
func _ready():
	self._initialize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self._rotateBackground(delta)
	self._handleInputs()
	
func _initialize():
	Main.setInLevelPlayingGameMode()

func _rotateBackground(delta):
	popossum.rotation_degrees.y += speed * delta

func _handleInputs():
	self._handleEndScreen()

func _handleEndScreen():		
	if(Input.is_action_just_pressed("display_end_screen_win") || Input.is_action_just_pressed("display_end_screen_lose")):
		if(Main.getCurrentGameMode() == Main.GAME_MODE.IN_LEVEL_LOST || Main.getCurrentGameMode() == Main.GAME_MODE.IN_LEVEL_WIN):
			return
					
		if(Input.is_action_just_pressed("display_end_screen_win")): Main.setInLevelWinGameMode()
		else: Main.setInLevelLostGameMode()
			
		var endScreenInstance = endScreen.instantiate()
		get_tree().current_scene.add_child(endScreenInstance)
