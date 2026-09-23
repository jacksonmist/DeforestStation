class_name Building extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

@export var repair_cost: int = 1
var amount_spent: int = 0
@export var destroyed: Texture2D
@export var texture: Texture2D
@export var max_health: float = 10
var health: float = 10
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
var chosen_target: Enemy
var sell_amount: int

signal clicked
signal max_level_reached
signal destroyed_signal
signal repaired_signal
signal target_changed


func _ready() -> void:
	for child in get_children():
		if child.has_method("setup"):
			child.setup(self)
	setup()
	_calculate_upgrade_cost()
	health = max_health

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
	amount_spent += current_upgrade_cost
	calculate_repair_cost()
	calculate_stats()
	if level == max_level:
		max_level_reached.emit()
	_calculate_upgrade_cost()
	return true

func calculate_stats():
	pass

func calculate_repair_cost():
	repair_cost = int(round((float(amount_spent) / 2)))

func _calculate_upgrade_cost():
	current_upgrade_cost = base_upgrade_cost * 2 ** (level - 1)

func set_active(active: bool):
	is_active = active
	monitorable = active

func take_damage(amount: float):
	if not is_active:
		return
	health -= amount
	if health <= 0:
		health = 0
		destroy()

func destroy():
	set_active(false)
	sprite.texture = destroyed
	destroyed_signal.emit()

func repair():
	sprite.texture = texture
	structure_manager.change_wood(-repair_cost)
	repaired_signal.emit()
	health = max_health
	set_active(true)

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
	sell_amount = int(round(float(amount_spent / 2)))
	structure_manager.sell_building(occupied_cells)
	structure_manager.change_wood(sell_amount)

func cleanup():
	queue_free()

func update_target(target: Enemy):
	chosen_target = target
	target_changed.emit()
