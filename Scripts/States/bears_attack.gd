class_name BearsAttack extends State

func enter_state() ->  void:
	parent.move(Vector2.ZERO)
	
func update(_delta: float) -> void:
	if parent.imm_targets.is_empty():
		sm.change_state(sm.states[BearsPatrol])
		return
