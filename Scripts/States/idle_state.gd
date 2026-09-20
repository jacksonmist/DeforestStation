class_name IdleState extends State

func enter_state() ->  void:
	pass
	
func update(_delta: float) -> void:
	if parent.wood_amount >= parent.max_wood:
		sm.change_state(sm.states[ReturnState])
		return
	if not parent.imm_targets.is_empty():
		sm.change_state(sm.states[AttackState])
		return
	if not parent.dis_targets.is_empty():
		sm.change_state(sm.states[ChaseState])
		return
	sm.change_state(sm.states[PatrolState])
	return
