class_name House extends Building

@export var player: Player
@export var difficulty_manager: DifficultyManager
@export var ground_map: GroundMap
@export var grid: GridManager
@export var starting_radius: int = 1
var cell: Vector2i
var radius: int

func setup():
	can_sell = false
	cell = Vector2i(floor(ground_map.cell_by_cell/2))
	grid.set_house_cell(cell)
	for i in range(starting_radius):
		grid.upgrade_circle()
	structure_manager.set_house(self)

func upgrade_level():
	if not grid.upgrade_circle():
		return false
	super()
	difficulty_manager.update_level(level)
	return true

func calculate_stats():
	max_health = base_max_health + (health_scale * (level - 1))

func update_radius(value: int):
	radius = value
