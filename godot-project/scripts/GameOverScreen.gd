extends Control

@onready var final_score_label = $Panel/FinalScore
@onready var high_score_label = $Panel/HighScore

func _ready():
	final_score_label.text = "YOUR SCORE: " + str(Global.score)
	
	var is_new_record = Global.score > Global.high_score
	high_score_label.text = ("NEW RECORD: " if is_new_record else "HIGH SCORE: ") + str(max(Global.score, Global.high_score))
	
	# MANDATORY: Save to Applaa Storage
	Global.save_game_result(Global.score)
	
	$Panel/RestartButton.pressed.connect(_on_restart)
	$Panel/MenuButton.pressed.connect(_on_menu)

func _on_restart():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")