class_name House extends Building

@export var difficulty_manager: DifficultyManager
@export var ground_map: GroundMap
@export var grid: GridManager
@export var starting_radius: int = 1
var cell: Vector2i

func setup():
	can_sell = false
	cell = Vector2i(floor(ground_map.cell_by_cell/2))
	grid.set_house_cell(cell)
	for i in range(starting_radius):
		upgrade_level()
	structure_manager.set_house(self)

func upgrade_level():
	super()
	grid.upgrade_circle()
	difficulty_manager.update_level(level)
	return true
