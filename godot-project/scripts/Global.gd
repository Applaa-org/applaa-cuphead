extends Node

var score: int = 0
var health: int = 3
var parries: int = 0
var high_score: int = 0
var last_player_name: String = ""
var game_id: String = "cuphead-clone-v1"

signal data_loaded

func _ready():
	# Initialize displays to 0 immediately in UI scripts
	load_game_data()

func add_score(points: int):
	score += points

func reset_game():
	score = 0
	health = 3
	parries = 0

func load_game_data():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({ 
				type: 'applaa-game-load-data', 
				gameId: '%s' 
			}, '*');
		""" % game_id)

func save_final_score(player_name: String):
	last_player_name = player_name
	if score > high_score:
		high_score = score
	
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({ 
				type: 'applaa-game-save-score', 
				gameId: '%s', 
				playerName: '%s', 
				score: %d 
			}, '*');
		""" % [game_id, player_name, score])

# This would be called by a JS callback in a real export
func _on_web_data_received(data: Dictionary):
	high_score = data.get("highScore", 0)
	last_player_name = data.get("lastPlayerName", "")
	data_loaded.emit()