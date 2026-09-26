class_name ReaperJack extends SpecialJack
@onready var attack_circle: AttackCircle = $AttackCircle

func set_stats():
	atk_range = 100
	attack_circle.update_range()

func attack():
	if not can_attack or not is_active:
		return
	for target in imm_targets:
		if chosen_target and imm_targets.has(chosen_target) and chosen_target.is_active:
			break
		if not target.is_active or not target:
			imm_targets.erase(target)
		elif target.has_method("set_active") and target.is_active and target:
			chosen_target = target
	if chosen_target and global_position.distance_to(chosen_target.position) < 16:
		chosen_target.take_damage(damage)
		can_attack = false
		timer.start()
