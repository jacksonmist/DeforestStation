class_name House extends Building

@export var ground_map: GroundMap
@export var grid: GridManager
@export var starting_radius: int = 1
var cell: Vector2i

func _ready() -> void:
	cell = Vector2i(floor(ground_map.cell_by_cell/2))
	grid.set_house_cell(cell)
	for i in range(starting_radius):
		upgrade_circle()
	structure_manager.set_house(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func upgrade_circle():
	grid.upgrade_circle()	
