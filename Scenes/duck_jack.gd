class_name DuckJack extends SpecialJack

@export var quack_proj: PackedScene

func attack():
	var knockback_value = 10
	if not can_attack or not is_active:
		return
	for target in imm_targets:
		if chosen_target and imm_targets.has(chosen_target) and chosen_target.is_active:
			break
		if target.has_method("set_active") and target.is_active:
			chosen_target = target
		elif not target.is_active:
			imm_targets.erase(target)
	if chosen_target:
		var direction = (chosen_target.position - global_position).normalized()
		var instance = quack_proj.instantiate()
		instance.setup(direction, 40, 0, 5, knockback_value)
		add_child(instance)
		can_attack = false
		timer.start()
