extends Control

@onready var high_score_label = $VBoxContainer/HighScoreLabel
@onready var name_input = $VBoxContainer/NameInput

func _ready():
	# MANDATORY: Initialize to 0
	high_score_label.text = "High Score: 0"
	high_score_label.visible = true
	
	Global.load_game_data()
	
	$VBoxContainer/StartButton.pressed.connect(_on_start)
	$VBoxContainer/CloseButton.pressed.connect(_on_close)
	
	# Simulated data load response
	get_tree().create_timer(0.5).timeout.connect(func():
		high_score_label.text = "High Score: " + str(Global.high_score)
		name_input.text = Global.player_name
	)

func _on_start():
	if name_input.text != "":
		Global.player_name = name_input.text
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close():
	get_tree().quit()