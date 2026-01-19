extends Control

@onready var score_label = $ScoreLabel
@onready var rank_label = $RankLabel

func _ready():
	score_label.text = "Final Score: " + str(Global.score)
	calculate_rank()
	
	# Save to localStorage
	Global.save_final_score(Global.last_player_name)
	
	$RestartButton.pressed.connect(_on_restart)
	$MenuButton.pressed.connect(_on_menu)
	$CloseButton.pressed.connect(_on_close)

func calculate_rank():
	if Global.score > 500: rank_label.text = "Rank: A+"
	elif Global.score > 300: rank_label.text = "Rank: B"
	else: rank_label.text = "Rank: C"

func _on_restart():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close():
	get_tree().quit()