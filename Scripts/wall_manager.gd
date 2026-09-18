class_name WallManager extends Node

const N = 1
const E = 2
const S = 4
const W = 8

@export var N_wall: PackedScene
@export var E_wall: PackedScene
@export var S_wall: PackedScene
@export var W_wall: PackedScene
@export var NE_wall: PackedScene
@export var SE_wall: PackedScene
@export var SW_wall: PackedScene
@export var NW_wall: PackedScene

var walls: Dictionary
var timer: Timer
@export var time_to_place: float = 2

func place_walls(border_cells: Dictionary, station_cells: Dictionary):
	if timer and not timer.is_stopped():
		await timer.timeout
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.wait_time = time_to_place / border_cells.size()
	for wall in walls.keys():
		walls[wall].queue_free()
	walls.clear()
	for cell in border_cells:
		if cell == Vector2i(25, 24) or cell == Vector2i(24, 23) or cell == Vector2i(23, 24) or cell == Vector2i(24, 25):
			continue
		var mask = 0
		if Vector2i(cell.x, cell.y -1) in station_cells:
			mask += N
		if Vector2i(cell.x + 1, cell.y) in station_cells:
			mask += E
		if Vector2i(cell.x, cell.y + 1) in station_cells:
			mask += S
		if Vector2i(cell.x - 1, cell.y) in station_cells:
			mask += W
		var wall_choice: PackedScene
		match mask:
			1:
				wall_choice = S_wall
			2:
				wall_choice = W_wall
			3:
				wall_choice = SW_wall
			4:
				wall_choice = N_wall
			6:
				wall_choice = NW_wall
			8:
				wall_choice = E_wall
			9:
				wall_choice = SE_wall
			12:
				wall_choice = NE_wall
		if wall_choice:
			if not timer.is_stopped():
				await timer.timeout
			timer.start()
			var instance = wall_choice.instantiate()
			add_child(instance)
			walls[cell] = instance
			instance.position = (cell - Vector2i(24, 24)) * 16
		
