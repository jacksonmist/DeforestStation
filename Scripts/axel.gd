class_name Axel extends Building
@onready var axe_head: Area2D = $AxePivot/CollisionShape2D
@onready var axe_pivot: Node2D = $AxePivot

var damage: float
@export var base_damage: float = 1
@export var damage_scale: float = 0
var rot_speed: float
@export var base_rotation_speed: float = 5
@export var rotation_speed_scale: float = 5
@export var base_scale: float = 1
@export var scale_increase: float = 0.1

func setup():
	calculate_stats()
	axe_head.area_entered.connect(_enemy_hit	)

func calculate_stats():
	damage = base_damage + (damage_scale * (level-1))
	rot_speed = base_rotation_speed + (rotation_speed_scale * (level-1))
	var scale_amt = base_scale + (scale_increase * (level-1))
	axe_pivot.scale = Vector2(scale_amt, scale_amt)
	max_health = base_max_health + (health_scale * (level - 1))
	print(max_health)

func _process(delta: float) -> void:
	if not is_active:
		return
	
	axe_pivot.rotation -= (rot_speed * delta)

func _enemy_hit(body):
	body.take_damage(damage)
