extends KinematicBody2D


var linear_vel = Vector2()

var SPEED = 75
var GRAVITY = 250

var MAX_JUMP_TIME = 0.1
var jump_time = 0
var can_jump = true

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

func _ready() -> void:
	$InvincibilityTimer.connect("timeout", self, "on_InvincibilityTimer_timeout")

func _physics_process(delta):
	
	linear_vel.y += GRAVITY * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Acceleration aproximation
	linear_vel.x = lerp(linear_vel.x, target_vel * SPEED, 0.5)
	
	# Jump
	jump_time += delta
	if on_floor:
		jump_time = 0
		can_jump = true
	else:
		if jump_time > MAX_JUMP_TIME:
			can_jump = false
		
	if can_jump and Input.is_action_just_pressed("jump"):
		can_jump = false
		linear_vel.y = -SPEED * 2
	
	# Attack
	var attacking = on_floor and Input.is_action_just_pressed("attack")
	
	if attacking or playback.get_current_node() == "attack":
		linear_vel.x = 0
	
	# Animation
	if on_floor:
		if linear_vel.length_squared() > 10:
			playback.travel("run")
		else:
			playback.travel("idle")
		if attacking:
			playback.travel("attack")
	else:
		if linear_vel.y > 0:
			playback.travel("fall")
		elif linear_vel.y < 0:
			playback.travel("jump")

	
	if facing_right and target_vel < 0:
		facing_right = false
		flip()
		
	if not facing_right and target_vel > 0:
		facing_right = true
		flip()

func flip():
	if facing_right:
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1
		
func fire():
	pass

func end_fire():
	pass
