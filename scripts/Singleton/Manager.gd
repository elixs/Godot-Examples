extends Node


var score = 0 setget set_score
signal score_changed(value)
func set_score(value):
	score = value
	emit_signal("score_changed", score)
