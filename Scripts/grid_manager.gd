class_name GridManager extends Node

var grid: Array[Vector2i]
@export var tree_manager: TreeManager
@export var ground_map: GroundMap
@export var wall_manager: WallManager
@export var structure_manager: StructureManager

var station_cells: Dictionary
var cached_cells: Array[Vector2i]

var current_radius: int = 0
var house_cell: Vector2i
var border_cells: Dictionary
var can_upgrade: bool = true

func set_house_cell(cell: Vector2i):
	house_cell = cell
	ground_map.set_station_floor(cell)
	station_cells[cell] = true

func upgrade_circle() -> bool:
	if not can_upgrade:
		return false
	var added_cells: Array[Vector2i]
	cached_cells = []
	var r2 = current_radius ** 2
	for x in range(-current_radius, current_radius + 1):
		for y in range(-current_radius, current_radius + 1):
			if (x ** 2) + (y ** 2) <= r2:
				var cell = (Vector2i(house_cell.x + x, house_cell.y + y))
				if not station_cells.has(cell):
					added_cells.append(cell)
	if not tree_manager.check_occupied(added_cells):
		for cell in added_cells:
			station_cells[cell] = true
			ground_map.set_station_floor(cell)
		calculate_border_cells(added_cells)
		current_radius += 1
		structure_manager.update_radius(current_radius)
		structure_manager.update_station_cells(station_cells)
	else:
		can_upgrade = false
		cached_cells = added_cells
	return true

func no_marked_trees():
	for cell in cached_cells:
		station_cells[cell] = true
		ground_map.set_station_floor(cell)
	calculate_border_cells(cached_cells)
	current_radius += 1
	structure_manager.update_radius(current_radius)
	structure_manager.update_station_cells(station_cells)
	can_upgrade = true

func calculate_border_cells(added_cells: Array[Vector2i]):
	border_cells.clear()
	var directions = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]
	
	for cell in station_cells:
		for direction in directions:
			var neighbor = Vector2i(cell + direction)
			if not station_cells.has(neighbor):
				border_cells[neighbor] = true
	wall_manager.place_walls(border_cells, station_cells)
