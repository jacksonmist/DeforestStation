class_name BearsPatrol extends State

var move_direction: Vector2

func enter_state() ->  void:
	var angle = randf_range(0, 2 * PI)
	move_direction = Vector2(cos(angle), sin(angle))

func update(_delta: float) -> void:
	if not parent.imm_targets.is_empty():
		sm.change_state(sm.states[BearsAttack])
		return
	parent.move(move_direction)
