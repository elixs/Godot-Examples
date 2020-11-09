extends KinematicBody2D


var linear_vel = Vector2()

var SPEED = 75
var GRAVITY = 250

var MAX_JUMP_TIME = 0.1
var jump_time = 0
var can_jump = true

var move_horizontal = true
var move_vertical = false

var invincible = false

var health = 100 setget set_health
func set_health(value):
	health = clamp(value, 0, 100)
	if health == 0:
		pass

var mana = 100 setget set_mana
func set_mana(value):
	mana = clamp(value, 0, 100)

var facing_right = true
onready var playback = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	linear_vel = move_and_slide(linear_vel)

	var target_vel = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	
	# Acceleration aproximation
	linear_vel = lerp(linear_vel, target_vel * SPEED, 0.5)

	# Animation
	if linear_vel.y > 0:
		playback.travel("fall")
	elif linear_vel.y < 0:
		playback.travel("jump")
	
	if facing_right and target_vel.x < 0:
		facing_right = false
		flip()
		
	if not facing_right and target_vel.x > 0:
		facing_right = true
		flip()

func flip():
	if facing_right:
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1
