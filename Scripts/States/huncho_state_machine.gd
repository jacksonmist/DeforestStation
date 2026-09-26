class_name HunchoStateManager extends SpecialJackStateManager
func setup(parent_ref: Entity):
	states = {
		HunchoPatrol: HunchoPatrol.new(),
		HunchoAttack: HunchoAttack.new()
	}
	parent = parent_ref
	for state in states.values():
		state.setup(parent, self)
		state.house = house
		print("Here1")
	if not initial_state: change_state(states[HunchoPatrol])
