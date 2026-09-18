class_name Building extends Area2D

@export var texture: Texture2D
@export var health: float
@export var structure_manager: StructureManager
@export var cell_size: Vector2i = Vector2i(1, 1)
@export var purchase_cost: int
@export var base_upgrade_cost: int = 10
@export var upgrade_factor: float = 2
var current_upgrade_cost: int
var level: int = 1
var max_level: int = 10

func upgrade_level():
	if level >= max_level:
		level = max_level
		return
	level += 1
	_calculate_upgrade_cost()

func _calculate_upgrade_cost():
	current_upgrade_cost = base_upgrade_cost * 2 ** (level - 1)

func set_active(active: bool):
	pass
