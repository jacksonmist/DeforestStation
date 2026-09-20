class_name EnemyIdleState extends State

func update(_delta: float) -> void:
	if house:
		print(parent.house)
		sm.change_state(sm.states[EnemySeekHouseState])
