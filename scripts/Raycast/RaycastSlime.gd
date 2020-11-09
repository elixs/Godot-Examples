extends "res://scripts/Slime.gd"

var MIN_WALL_DIST = 20

func _ready() -> void:
	$Line2D.set_as_toplevel(true)
	$RayCast2D.cast_to = Vector2(MIN_WALL_DIST, 0)
	$RayCast2D2.cast_to = Vector2(-MIN_WALL_DIST, 0)

func fire():
	var start = $Pivot/Attack.global_position
	var end = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(start, end, [], 1)
	
	if result:
		end = result.position
		
		# Apply impulse if colliding with rigid body
		if result.collider is RigidBody2D:
			var offset = end - result.collider.global_position
			var impulse = (end - start).normalized() * 100
			(result.collider as RigidBody2D).apply_impulse(offset, impulse)
		
	# Show a line
	$Line2D.points[0] = start
	$Line2D.points[1] = end
	$Line2D.show()

func end_fire():
	$Line2D.hide()

func flip():
	.flip()
	if facing_right:
		$Pivot.scale.x = 1
	else:
		$Pivot.scale.x = -1

func _physics_process(delta: float) -> void:
	
	# Change the modulate saturation when near a wall
	var wall_dist = MIN_WALL_DIST
	
	if $RayCast2D.is_colliding():
		wall_dist = min(wall_dist, ($RayCast2D.get_collision_point() - global_position).length())
	
	if $RayCast2D2.is_colliding():
		wall_dist = min(wall_dist, ($RayCast2D2.get_collision_point() - global_position).length())
	
	$Sprite.modulate.s = 1 - wall_dist / MIN_WALL_DIST
