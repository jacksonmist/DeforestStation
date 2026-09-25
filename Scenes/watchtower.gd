class_name Watchtower extends Building

@onready var structure_attack_circle: StructureAttackCircle = $StructureAttackCircle

@export var base_attack_range: float = 64.0
@export var attack_range_scale: float = 16.0
var attack_range: float

@export var base_damage: float = 1
@export var damage_scale: float = 0.5
var damage: float

@export var base_cooldown: float = 3
@export var cooldown_scale: float = -0.25
var cooldown: float

var knockback: float = 0.0

func setup():
	attack_range = base_attack_range
	cooldown = base_cooldown
	damage = base_damage
	structure_attack_circle.set_range(attack_range)

func calculate_stats():
	attack_range = base_attack_range + (attack_range_scale * (level - 1))
	structure_attack_circle.set_range(attack_range)
	damage = base_damage + (damage_scale * (level - 1))
	cooldown = base_cooldown + (cooldown_scale * (level - 1))
