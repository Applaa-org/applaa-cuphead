extends Control

@onready var high_score_label = $VBoxContainer/HighScoreLabel
@onready var name_input = $VBoxContainer/NameInput

func _ready():
	# MANDATORY: Initialize to 0 immediately
	high_score_label.text = "High Score: 0"
	high_score_label.visible = true
	
	# Load data from Applaa Storage
	Global.load_game_data()
	
	# Connect buttons
	$VBoxContainer/StartButton.pressed.connect(_on_start)
	$VBoxContainer/CloseButton.pressed.connect(_on_close)
	
	# Update UI when data arrives (simulated here)
	get_tree().create_timer(0.5).timeout.connect(_refresh_ui)

func _refresh_ui():
	high_score_label.text = "High Score: " + str(Global.high_score)
	name_input.text = Global.last_player_name

func _on_start():
	Global.last_player_name = name_input.text
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close():
	get_tree().quit()