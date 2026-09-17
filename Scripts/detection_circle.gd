class_name AttackCircle extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D

var target_list: Array[Node2D]
var parent: Entity

func setup(parent_ref: Entity):
	parent = parent_ref
	area_entered.connect(target_entered)
	area_exited.connect(target_exited)
	set_layer_mask()
	collision.shape = collision.shape.duplicate()
	update_range()

func set_layer_mask():
	if parent.entity_allegience == parent.allegience.friendly:
		set_collision_layer_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
	else:
		set_collision_layer_value(2, true)
		set_collision_mask_value(1, true)

func target_entered(body):
	if not target_list.has(body):
		target_list.append(body)
		update_targets()
	
func target_exited(body):
	if target_list.has(body):
		target_list.erase(body)
		update_targets()

func update_targets():
	parent.update_immediate_targets(target_list)

func update_range():
	collision.shape.radius = parent.atk_range
