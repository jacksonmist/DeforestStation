class_name EnemySeekHouseState extends State

var vec_to_house: Vector2

func enter_state() ->  void:
	vec_to_house = (house.position - parent.global_position).normalized()
	parent.move(vec_to_house)

func update(_delta: float) -> void:
	if not parent.imm_targets.is_empty():
		sm.change_state(sm.states[EnemyAttackState])
		return
