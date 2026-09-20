class_name PatrolState extends State

var move_direction: Vector2
func enter_state() ->  void:
	var angle = randf_range(0, 2 * PI)
	move_direction = Vector2(cos(angle), sin(angle))
	
func update(_delta: float) -> void:
	if parent.wood_amount >= parent.max_wood:
		sm.change_state(sm.states[ReturnState])
		return
	if not parent.imm_targets.is_empty():
		sm.change_state(sm.states[AttackState])
		return
	if not parent.dis_targets.is_empty():
		sm.change_state(sm.state[ChaseState])
		return
	parent.move(move_direction)
