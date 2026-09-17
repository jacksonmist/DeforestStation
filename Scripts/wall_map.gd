class_name WallMap extends TileMapLayer

const N = 1
const E = 2
const S = 4
const W = 8

var walls: Array[Vector2i]

func place_walls(border_cells: Dictionary, station_cells: Dictionary):
	clear()
	walls.clear()
	for cell in border_cells:
		var mask = 0
		if Vector2i(cell.x, cell.y -1) in station_cells:
			mask += N
		if Vector2i(cell.x + 1, cell.y) in station_cells:
			mask += E
		if Vector2i(cell.x, cell.y + 1) in station_cells:
			mask += S
		if Vector2i(cell.x - 1, cell.y) in station_cells:
			mask += W
		match mask:
			1:
				set_cell(cell, 1, Vector2i(1, 2))
			2:
				set_cell(cell, 1, Vector2i(0, 1))
			3:
				set_cell(cell, 1, Vector2i(0, 2))
			4:
				set_cell(cell, 1, Vector2i(1, 0))
			6:
				set_cell(cell, 1, Vector2i(0, 0))
			8:
				set_cell(cell, 1, Vector2i(2, 1))
			9:
				set_cell(cell, 1, Vector2i(2, 2))
			12:
				set_cell(cell, 1, Vector2i(2, 0))
