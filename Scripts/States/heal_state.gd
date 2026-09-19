class_name HealState extends State

func enter_state() ->  void:
	print("Heal")
	parent.move(Vector2.ZERO)
	barracks.start_healing(parent)
	parent.set_active(false)
	
func update(_delta: float) -> void:
	if parent.health == parent.max_health:
		barracks.stop_healing(parent)
		parent.set_active(true)
		sm.change_state(sm.states[IdleState])
		return
