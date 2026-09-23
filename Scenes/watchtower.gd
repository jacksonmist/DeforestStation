class_name Watchtower extends Building

@onready var structure_attack_circle: StructureAttackCircle = $StructureAttackCircle

var projectile: PackedScene

@export var base_attack_range: float = 64.0
var attack_range: float
var attack_range_scale: float = 16.0

@export var base_damage: float = 1
var damage: float
var damage_scale: = 2


func setup():
	attack_range = base_attack_range
	structure_attack_circle.set_range(attack_range)
	damage = base_damage
