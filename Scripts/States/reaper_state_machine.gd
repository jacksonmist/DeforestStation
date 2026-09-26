class_name ReaperStateManager extends SpecialJackStateManager
func setup(parent_ref: Entity):
	states = {
		ReaperIdle: ReaperIdle.new(),
		ReaperAttack: ReaperAttack.new()
	}
	parent = parent_ref
	for state in states.values():
		state.setup(parent, self)
		state.house = house
	if not initial_state: change_state(states[ReaperIdle])
