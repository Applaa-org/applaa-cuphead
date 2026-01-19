extends CanvasLayer

@onready var score_label = $Control/ScoreLabel
@onready var high_score_label = $Control/HighScoreLabel

func _ready():
	# MANDATORY: Initialize to 0
	high_score_label.text = "BEST: 0"
	high_score_label.visible = true
	update_display()

func _process(_delta):
	update_display()

func update_display():
	score_label.text = "SCORE: %05d" % Global.score
	# Update high score in real-time if beaten
	var current_best = max(Global.score, Global.high_score)
	high_score_label.text = "BEST: %05d" % current_best