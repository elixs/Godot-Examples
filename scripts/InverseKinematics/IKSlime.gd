extends "res://scripts/Slime.gd"

var arm_sections = 2
var arm_section_lenght = 32
var joint_positions = []
var joint_distances = []
var arm_length = 0
var target = Vector2()

func _ready() -> void:
	for i in arm_sections + 1:
		joint_positions.append(Vector2(0, -i * arm_section_lenght))
		$Line2D.add_point(joint_positions[i])
		if i < arm_sections:
			joint_distances.append(arm_section_lenght)
			arm_length += arm_section_lenght
	

# FABRIK
func solve_ik():
	var target = get_local_mouse_position()
	# Calculate distances
	var target_dist = (joint_positions[0] - target).length()
	if target_dist > arm_length:
		for i in arm_sections - 1:
			var r = (target - joint_positions[i]).length()
			var l = joint_distances[i]/r
			joint_positions[i + 1] = (1 - l)*joint_positions[i] + l * target

func update_line():
	for i in arm_sections + 1:
		$Line2D.points[i] = joint_positions[i]

func _physics_process(delta: float) -> void:
	solve_ik()
	update_line()
