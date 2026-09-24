class_name AttackComponent extends Node2D

var chosen_target: Enemy
var first_target: bool = true
var parent: Building
@export var projectile: PackedScene
var timer: Timer

@export var proj_speed: float = 20
@export var proj_time: float = 3

func setup(parent_ref: Building):
	parent = parent_ref
	timer = Timer.new()
	add_child(timer)
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(attack)
	parent.target_changed.connect(update_target)

func attack():
	if not chosen_target:
		return
	var direction_to_target = (chosen_target.position - global_position).normalized()
	var instance = projectile.instantiate()
	call_deferred("add_child", instance)
	instance.setup(direction_to_target, proj_speed, parent.damage, proj_time)
	timer.wait_time = parent.cooldown
	timer.start()

func update_target():
	chosen_target = parent.chosen_target
	if not chosen_target:
		first_target = true
	if first_target and chosen_target:
		attack()
