class_name MissileSilo extends Building

@onready var atk_circle: StructureAttackCircle = $StructureAttackCircle
@onready var timer: Timer = $Timer

@export var missile: PackedScene
var spawn_pos := Vector2(16.0, 16.0)
var damage: float
var missile_range: float
var cooldown: float
var atk_range: float

var cooldown_scale: float = -1.0
var missile_range_scale: float  = 8.0
var damage_scale = 5.0
var atk_range_scale: float = 16.0

@export var base_atk_range: float = 128.0
@export var base_damage: float = 10.0
@export var base_missile_range: float = 64.0
@export var base_cooldown: float = 10.0

func setup():
	calculate_stats()
	target_changed.connect(attack)
	timer.timeout.connect(attack)

func calculate_stats():
	damage = base_damage + (damage_scale * (level - 1))
	missile_range = base_missile_range + (missile_range_scale * (level - 1))
	cooldown = base_cooldown + (cooldown_scale * (level - 1))
	atk_range = base_atk_range + (atk_range_scale * (level - 1))
	atk_circle.set_range(atk_range)
	timer.wait_time = cooldown

func launch_missile(target: Vector2):
	var instance = missile.instantiate()
	instance.position = spawn_pos
	call_deferred("add_child", instance)
	instance.launch_sequence(target, damage, missile_range)

func attack():
	if not chosen_target or not timer.is_stopped():
		return
	launch_missile(chosen_target.position)
	timer.start()
