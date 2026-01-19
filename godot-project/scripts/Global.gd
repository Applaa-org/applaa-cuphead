extends Node

var game_id: String = "cuphead_rubber_hose_v2"
var score: int = 0
var high_score: int = 0
var player_name: String = "Cuphead"
var health: int = 3

signal data_loaded

func _ready():
	# Initialize high score to 0 immediately
	high_score = 0
	load_game_data()

func load_game_data():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({ 
				type: 'applaa-game-load-data', 
				gameId: '%s' 
			}, '*');
		""" % game_id)

func save_game_result(final_score: int):
	if final_score > high_score:
		high_score = final_score
	
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({ 
				type: 'applaa-game-save-score', 
				gameId: '%s', 
				playerName: '%s', 
				score: %d 
			}, '*');
		""" % [game_id, player_name, final_score])

func reset_game():
	score = 0
	health = 3