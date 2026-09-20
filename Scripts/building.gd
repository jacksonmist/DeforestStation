class_name Building extends Area2D

@export var destroyed: Texture2D
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
var can_sell: bool = true
var origin: Vector2i
var occupied_cells: Array[Vector2i]
var is_active: bool = false

signal clicked
signal max_level_reached

func _ready() -> void:
	for child in get_children():
		if child.has_method("setup"):
			child.setup(self)
	setup()
	calculate_stats()
	_calculate_upgrade_cost()

func setup():
	pass

func upgrade_level() -> bool:
	if level >= max_level:
		level = max_level
		return false
	if structure_manager.wood_amount < current_upgrade_cost:
		return false
	level += 1
	structure_manager.change_wood(-current_upgrade_cost)
	calculate_stats()
	if level == max_level:
		max_level_reached.emit()
	_calculate_upgrade_cost()
	return true

func calculate_stats():
	pass

func _calculate_upgrade_cost():
	current_upgrade_cost = base_upgrade_cost * 2 ** (level - 1)

func set_active(active: bool):
	is_active = active

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LeftMouse"):
		clicked.emit()

func set_structure_manager(sm: StructureManager):
	structure_manager = sm

func set_origin(cell: Vector2i):
	origin = cell
	for x in cell_size.x:
		for y in cell_size.y:
			occupied_cells.append(origin + Vector2i(x, y))

func get_cells() -> Array[Vector2i]:
	return occupied_cells

func sell():
	if not can_sell:
		return
	structure_manager.sell_building(occupied_cells)

func cleanup():
	queue_free()
