class_name StructureAttackCircle extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D

var targets: Array[Enemy]
var chosen_target: Enemy
var parent: Building
var range: float

func setup(parent_ref: Building):
	parent = parent_ref
	area_entered.connect(enemy_entered)
	area_exited.connect(enemy_exited)

func set_range(value: float):
	range = value
	collision.shape.radius = range

func enemy_entered(body):
	if not targets.has(body):
		targets.append(body)
		choose_target()

func enemy_exited(body):
	if targets.has(body):
		targets.erase(body)
		if chosen_target == body:
			choose_target()

func choose_target():
	for target in targets:
		if target and target.is_active:
			if target != chosen_target:
				parent.update_target(target)
			chosen_target = target
			return
	chosen_target = null
