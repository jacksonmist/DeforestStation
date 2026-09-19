class_name ReturnState extends State

var vec_to_barracks: Vector2

func enter_state() ->  void:
	print("return")
	vec_to_barracks = (barracks.position - parent.global_position).normalized()
	parent.move(vec_to_barracks)
	
func update(_delta: float) -> void:
	if not vec_to_barracks:
		return
	var distance_to_barracks = parent.global_position.distance_to(barracks.position)
	if distance_to_barracks > 8:
		return
	barracks.deposit_wood(parent)
	if parent.health == parent.max_health:
		sm.change_state(sm.states[PatrolState])
		return
	else:
		sm.change_state(sm.states[HealState])
