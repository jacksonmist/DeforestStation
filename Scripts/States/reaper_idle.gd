class_name ReaperIdle extends State

func enter_state() ->  void:
	print("idle")
	parent.move(Vector2.ZERO)

func update(_delta: float) -> void:
	if parent.can_attack:
		sm.change_state(sm.states[ReaperAttack])
