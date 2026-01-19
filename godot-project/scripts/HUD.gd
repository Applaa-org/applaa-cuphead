extends CanvasLayer

@onready var score_label = $Control/ScoreLabel
@onready var high_score_label = $Control/HighScoreLabel

func _ready():
	# MANDATORY: Initialize to 0
	high_score_label.text = "BEST: 0"
	high_score_label.visible = true

func _process(_delta):
	score_label.text = "SCORE: %05d" % Global.score
	# Real-time high score update
	var display_best = max(Global.score, Global.high_score)
	high_score_label.text = "BEST: %05d" % display_best