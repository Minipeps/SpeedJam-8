extends Node

var TIME_ELAPSED : float

func get_formulated_time_elapsed() -> String:
	var minutes : int = TIME_ELAPSED / 60.0
	var seconds : int = fmod(TIME_ELAPSED, 60.0)
	var microseconds : int = (TIME_ELAPSED - int(TIME_ELAPSED)) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, microseconds]

# Leaderboard
var LEADERBOARD_NAME_ENTRIES: Array
var LEADERBOARD_TIME_ENTRIES: Array

func _ready():
	load_leaderboard_from_file()

func add_leaderboard_entry(username: String, time: float):
	var insert_index: int = 0
	for entry in Globals.LEADERBOARD_TIME_ENTRIES:
		if time < entry:
			break;
		insert_index += 1
	
	LEADERBOARD_TIME_ENTRIES.insert(insert_index, time)
	LEADERBOARD_NAME_ENTRIES.insert(insert_index, username)
	
	save_leaderboard_to_file()
	print("Score saved to leaderboard: ", username, ": ", time)

func save_leaderboard_to_file():
	var data = {"usernames": LEADERBOARD_NAME_ENTRIES, "times": LEADERBOARD_TIME_ENTRIES}
	var save_file = FileAccess.open("user://leaderboard.save", FileAccess.WRITE)
	var json = JSON.stringify(data)
	save_file.store_line(json)

func load_leaderboard_from_file():
	if not FileAccess.file_exists("user://leaderboard.save"):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open("user://leaderboard.save", FileAccess.READ)
	var json_string = save_file.get_line()

	# Creates the helper class to interact with JSON.
	var json = JSON.new()

	# Check if there is any error while parsing the JSON string, skip in case of failure.
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	# Get the data from the JSON object.
	var data = json.data
	LEADERBOARD_NAME_ENTRIES = data["usernames"]
	LEADERBOARD_TIME_ENTRIES = data["times"]
