extends Control

@onready var final_score_label = $Panel/FinalScore
@onready var high_score_label = $Panel/HighScore
@onready var new_record_label = $Panel/NewRecord

func _ready():
	final_score_label.text = "YOUR SCORE: " + str(Global.score)
	
	if Global.score > Global.high_score:
		new_record_label.visible = true
		high_score_label.text = "NEW HIGH SCORE!"
	else:
		new_record_label.visible = false
		high_score_label.text = "HIGH SCORE: " + str(Global.high_score)
	
	# Save to Applaa Storage
	Global.save_score(Global.last_player_name, Global.score)
	
	$Panel/RestartButton.pressed.connect(_on_restart)
	$Panel/MenuButton.pressed.connect(_on_menu)

func _on_restart():
	Global.reset_session()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu():
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")