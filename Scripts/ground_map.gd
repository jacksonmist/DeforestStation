class_name GroundMap extends TileMapLayer

@export var pds_manager: PDSManager
var cell_by_cell := Vector2i(49, 49)
var position_offest = Vector2(cell_by_cell/2) * 16

var basic_ground: int = 0
var station_floor: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position -= position_offest
	for x in cell_by_cell.x:
		for y in cell_by_cell.y:
			set_cell(Vector2i(x, y), basic_ground, Vector2i.ZERO)
	pds_manager.generate_points(cell_by_cell.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_station_floor(cell: Vector2i):
	set_cell(cell, station_floor, Vector2i.ZERO)
