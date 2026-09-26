class_name BearsStateManager extends SpecialJackStateManager
func setup(parent_ref: Entity):
	states = {
		BearsPatrol: BearsPatrol.new(),
		BearsAttack: BearsAttack.new()
	}
	parent = parent_ref
	for state in states.values():
		state.setup(parent, self)
	if not initial_state: change_state(states[BearsPatrol])
