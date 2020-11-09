extends Area2D

var should_destroy = true

var velocity = Vector2()

signal disabled

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func enable():
	$CollisionShape2D.set_deferred("disabled", false)

func disable():
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("disabled", self)

func on_body_entered(body: Node):
	if body.is_in_group("slime"):
		disable()
		Manager.score += 10
		if should_destroy:
			queue_free()

func _physics_process(delta: float) -> void:
	position += velocity * delta
