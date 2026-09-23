class_name EnemyIdleState extends State

func update(_delta: float) -> void:
	if house:
		sm.change_state(sm.states[EnemySeekHouseState])
