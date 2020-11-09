extends Node2D

var BG_SPEED = 100

var zoom = 1

var Diamond = preload("res://scenes/Diamond.tscn")

var MIN_DIAMONDS = 10
var MAX_DIAMONDS = 29

func _ready() -> void:
	# Add initial diamonds
	for i in range(MAX_DIAMONDS / 2):
		add_diamond()
	$Timer.connect("timeout", self, "on_timeout")
	Manager.connect("score_changed", self, "on_score_changed")

func on_score_changed(value):
	$CanvasLayer/Score/Value.text = str(value)

func _physics_process(delta: float) -> void:
	$TileMap.position.x -= delta * BG_SPEED
	$TileMap.position.x = fmod($TileMap.position.x, 480)
	
	var tzoom = int(Input.is_action_just_released("zoom_out")) - int(Input.is_action_just_released("zoom_in"))
	zoom = clamp(zoom + tzoom * delta * 4, 1, 3)
	$Camera2D.zoom = Vector2.ONE * zoom
	
	# Return diamond if outside the screen
	for diamond in $Diamonds.get_children():
		if diamond.global_position.x < $Limit.global_position.x:
			return_diamond(diamond)
	
	if Input.is_action_just_pressed("ui_up"):
		add_diamond()
	if Input.is_action_just_pressed("ui_down"):
		remove_diamond()
		
func on_timeout():
	var diamond = get_diamond()
	$Diamonds.add_child(diamond)
	diamond.global_position = $Path2D.curve.interpolate(0, randf())
	diamond.velocity = Vector2(-2 * randf() * BG_SPEED, 0)

func add_diamond():
	if $Pool.get_child_count() >= MAX_DIAMONDS:
		for i in MIN_DIAMONDS:
			remove_diamond()
		return
	var diamond = Diamond.instance()
	$Pool.add_child(diamond)
	diamond.position = Vector2(16 * $Pool.get_child_count(), 0)
	diamond.connect("disabled", self, "return_diamond")
	diamond.should_destroy = false

func get_diamond():
	var diamond: Node = $Pool.get_child($Pool.get_child_count() - 1)
	$Pool.remove_child(diamond)
	if $Pool.get_child_count() == 0:
		for i in MIN_DIAMONDS:
			add_diamond()
	return diamond

func remove_diamond():
	var diamond = get_diamond()
	diamond.queue_free()


func return_diamond(diamond):
	$Diamonds.remove_child(diamond)
	$Pool.add_child(diamond)
	diamond.position = Vector2(16 * $Pool.get_child_count(), 0)
	diamond.velocity = Vector2()
	diamond.enable()
	
	if $Pool.get_child_count() >= MAX_DIAMONDS:
		for i in MIN_DIAMONDS:
			remove_diamond()
