extends Node

var game_id: String = "cuphead_rubber_hose_v1"
var score: int = 0
var high_score: int = 0
var last_player_name: String = "Cuphead"
var health: int = 3

signal data_loaded

func _ready():
	load_game_data()

func load_game_data():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("""
			window.parent.postMessage({ 
				type: 'applaa-game-load-data', 
				gameId: '%s' 
			}, '*');
			
			window.addEventListener('message', (event) => {
				if (event.data.type === 'applaa-game-data-loaded') {
					const data = event.data.data;
					if (data) {
						const godotData = JSON.stringify({
							"highScore": data.highScore || 0,
							"lastPlayerName": data.lastPlayerName || "Cuphead"
						});
						// We use a signal or a global variable to pass this back
						// In a real export, you'd use a callback to a Godot object
					}
				}
			});
		""" % game_id)

func save_score(player_name: String, final_score: int):
	last_player_name = player_name
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

func reset_session():
	score = 0
	health = 3