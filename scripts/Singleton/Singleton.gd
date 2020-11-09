extends Node2D


func _ready() -> void:
	Manager.connect("score_changed", self, "on_score_changed")

func on_score_changed(value):
	$CanvasLayer/Score/Value.text = str(value)
