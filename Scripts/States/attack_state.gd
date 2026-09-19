class_name AttackState extends State

func enter_state() ->  void:
	print("Attack")
	parent.move(Vector2.ZERO)
	
func update(_delta: float) -> void:
	if parent.is_low_health or parent.wood_amount >= parent.max_wood:
		sm.change_state(sm.states[ReturnState])
		return
	if parent.imm_targets.is_empty() and not parent.dis_targets.is_empty():
		sm.change_state(sm.states[ChaseState])
		return
	if parent.imm_targets.is_empty() and parent.dis_targets.is_empty():
		sm.change_state(sm.states[PatrolState])
		return
