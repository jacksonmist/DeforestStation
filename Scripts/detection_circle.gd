class_name FriendlyAttackCircle extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D

var target_list: Array[Node2D]
var parent: Entity

func setup(parent_ref: Entity):
	parent = parent_ref
	area_entered.connect(target_entered)
	area_exited.connect(target_exited)
	collision.shape = collision.shape.duplicate()
	update_range()

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
