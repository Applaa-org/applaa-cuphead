extends Control

@onready var high_score_label = $HighScoreLabel
@onready var name_input = $NameInput

func _ready():
	# Mandatory: Initialize to 0
	high_score_label.text = "High Score: 0"
	
	# Connect buttons
	$StartButton.pressed.connect(_on_start_pressed)
	$CloseButton.pressed.connect(_on_close_pressed)
	
	# Load data
	Global.data_loaded.connect(_update_ui)
	Global.load_game_data()

func _update_ui():
	high_score_label.text = "High Score: " + str(Global.high_score)
	name_input.text = Global.last_player_name

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()