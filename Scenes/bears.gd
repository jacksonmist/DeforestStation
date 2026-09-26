class_name BearsJack extends SpecialJack

var rot_speed = 3.5

func set_stats():
	area_entered.connect(wood_entered)

func _process(delta: float) -> void:
	if not imm_targets.is_empty():
		attack()

	position += (move_direction * speed * delta)
	walk_time += delta
	var dir_mod = 1 if move_direction.x >= 0 else -1
	rotation += (dir_mod * rot_speed * delta)

func wood_entered(body):
	var noise = Vector2(randf_range(-16, 16), randf_range(-16, 16))
	body.throw(Vector2.ZERO + noise)
