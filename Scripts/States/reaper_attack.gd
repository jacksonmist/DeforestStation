class_name ReaperAttack extends State

var direction: Vector2

func enter_state() ->  void:
	print("attack")
	if parent.chosen_target:
		direction = (parent.chosen_target - parent.global_position).normalized()

func update(_delta: float) -> void:
	if not parent.can_attack:
		sm.change_state(sm.states[ReaperIdle])
		return
	if parent.chosen_target:
		direction = (parent.chosen_target.position - parent.global_position).normalized()
	parent.move(direction)
