class_name HunchoJack extends SpecialJack

@export var bullet: PackedScene
@onready var gun_pivot_1: Node2D = $GunPivot1
@onready var gun_pivot_2: Node2D = $GunPivot2
@onready var gun_pivot_3: Node2D = $GunPivot3
@onready var gun_pivot_4: Node2D = $GunPivot4
@onready var attack_circle: AttackCircle = $AttackCircle

@onready var pivot_array = [gun_pivot_1, gun_pivot_2, gun_pivot_3, gun_pivot_4]

func set_stats():
	atk_range = 50
	attack_circle.update_range()

func attack():
	var chosen_targets: Array = []
	if not can_attack or not is_active:
			return

	for i in 4:
		for target in imm_targets:
			if chosen_targets.has(target):
				continue
			if target.has_method("set_active") and target.is_active:
				chosen_targets.append(target)
			elif not target.is_active():
				imm_targets.erase(target)
	
	if chosen_targets.is_empty():
		return
	for i in 4 - chosen_targets.size():
		chosen_targets.append(chosen_targets.pick_random())
	
	var i = 0
	for target in chosen_targets:
		var direction = (target.position - global_position).normalized()
		var instance = bullet.instantiate()
		instance.setup(direction, 40, 2, 5, 0)
		add_child(instance)
		pivot_array[i].rotation = direction.angle()
		i += 1
		i = clamp(i, 0, 3)
		
	can_attack = false
	timer.start()
