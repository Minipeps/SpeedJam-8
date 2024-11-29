extends Node

enum GAME_MODE {IN_LEVEL_PLAYING, IN_LEVEL_WIN, IN_LEVEL_LOST, IN_LEVEL_PAUSE, IN_MAIN_MENU_MAIN, IN_MAIN_MENU_TUTORIAL}

@onready var _CurrentGameMode: GAME_MODE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
func getCurrentGameMode():
	print(GAME_MODE.keys()[_CurrentGameMode])
	return _CurrentGameMode

func setInLevelPlayingGameMode():
	_CurrentGameMode = GAME_MODE.IN_LEVEL_PLAYING
	print(GAME_MODE.keys()[_CurrentGameMode])

func setInLevelWinGameMode():
	_CurrentGameMode = GAME_MODE.IN_LEVEL_WIN
	print(GAME_MODE.keys()[_CurrentGameMode])

func setInLevelLostGameMode():
	_CurrentGameMode = GAME_MODE.IN_LEVEL_LOST
	print(GAME_MODE.keys()[_CurrentGameMode])
		
func setInLevelPauseGameMode(gameIsPaused):
	_CurrentGameMode = GAME_MODE.IN_LEVEL_PLAYING if gameIsPaused else GAME_MODE.IN_LEVEL_PAUSE
	print(GAME_MODE.keys()[_CurrentGameMode])

func setInMainMenuMainGameMode():
	_CurrentGameMode = GAME_MODE.IN_MAIN_MENU_MAIN
	print(GAME_MODE.keys()[_CurrentGameMode])

func setInMainMenuTutorialGameMode():
	_CurrentGameMode = GAME_MODE.IN_MAIN_MENU_TUTORIAL
	print(GAME_MODE.keys()[_CurrentGameMode])
