extends Area2D

onready var playback = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("slime"):
		playback.travel("explode")
		body.queue_free()
	
func restart():
	get_tree().reload_current_scene()
