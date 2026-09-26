class_name DuckStateManager extends SpecialJackStateManager

func setup(parent_ref: Entity):
	states = {
		DuckPatrol: DuckPatrol.new(),
		DuckAttack: DuckAttack.new()
	}
	parent = parent_ref
	for state in states.values():
		state.setup(parent, self)
	if not initial_state: change_state(states[DuckPatrol])
