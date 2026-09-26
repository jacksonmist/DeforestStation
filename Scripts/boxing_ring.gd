class_name BoxingRing extends Building

@onready var attack_circle: StructureAttackCircle = $StructureAttackCircle

var damage: float = 0.0

@export var base_cooldown: float = 5
@export var cooldown_scale: float = -0.5
var cooldown: float = 5

var knockback: float = 20.0

func setup():
	cooldown - base_cooldown

func calculate_stats():
	cooldown = base_cooldown + (cooldown_scale * (level - 1))
	max_health = base_max_health + (health_scale * (level - 1))
