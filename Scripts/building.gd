class_name Building extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var building_menu: BuildingMenu = $BuildingMenu
@onready var healthbar: TextureProgressBar = $Healthbar
var healthbar_gradient: Gradient = Gradient.new()
var full_health_color: Color = Color("abff7a")
var no_health_color: Color = Color("ff7a7a")

@export var repair_cost: int = 1
var amount_spent: int = 0
@export var destroyed: Texture2D
@export var texture: Texture2D
@export var max_health: float = 10
var health: float = 10
@export var health_scale: float = 5
var base_max_health: float = 10
@export var structure_manager: StructureManager
@export var cell_size: Vector2i = Vector2i(1, 1)
@export var purchase_cost: int
@export var base_upgrade_cost: int = 10
@export var upgrade_factor: float = 2
var current_upgrade_cost: int
var level: int = 1
@export var max_level: int = 10
var can_sell: bool = true
var can_upgrade: bool = true
var origin: Vector2i
var occupied_cells: Array[Vector2i]
var is_active: bool = true
var chosen_target: Enemy
var sell_amount: int

var damaged_tween: Tween
@export var damaged_color: Color = Color("79444a")
var damaged_time: float = 0.3

signal clicked
signal max_level_reached
signal damaged
signal destroyed_signal
signal repaired_signal
signal target_changed
signal prices_changed

func _ready() -> void:
	setup()
	for child in get_children():
		if child.has_method("setup"):
			child.setup(self)
	_calculate_upgrade_cost()
	health = max_health
	base_max_health = max_health
	amount_spent += purchase_cost
	sell_amount = int(round(float(amount_spent / 2)))
	prices_changed.emit()
	
	healthbar_gradient.set_color(0, no_health_color)
	healthbar_gradient.set_color(1, full_health_color)
	healthbar_gradient.set_offset(0, 0.0)
	healthbar_gradient.set_offset(1, 1.0)
	update_health_bar()

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
	sell_amount = int(round(float(amount_spent / 2)))
	calculate_repair_cost()
	calculate_stats()
	if level == max_level:
		max_level_reached.emit()
	_calculate_upgrade_cost()
	prices_changed.emit()
	update_health_bar()
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
	if damaged_tween and damaged_tween.is_running():
		damaged_tween.kill()
	damaged_tween = create_tween()
	damaged_tween.tween_property(self, "modulate", damaged_color, damaged_time / 2)
	damaged_tween.tween_property(self, "modulate", Color.WHITE, damaged_time / 2)
	health -= amount
	update_health_bar()
	damaged.emit()
	if health <= 0:
		health = 0
		destroy()

func heal(amount: float):
	health += amount
	update_health_bar()
	if health > max_health:
		health = max_health

func destroy():
	set_active(false)
	sprite.texture = destroyed
	destroyed_signal.emit()

func repair() -> bool:
	if structure_manager.wood_amount < repair_cost:
		return false
	sprite.texture = texture
	structure_manager.change_wood(-repair_cost)
	repaired_signal.emit()
	health = max_health
	set_active(true)
	update_health_bar()
	return true

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

func building_placed():
	amount_spent += purchase_cost

func update_health_bar():
	healthbar.visible = false if health == max_health else true
	healthbar.tint_progress = healthbar_gradient.sample(health / max_health)
	healthbar.value = ((health / max_health) * 50) + 12.5
