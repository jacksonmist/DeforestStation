class_name PoissonDiscSampler

var r: float = 20 # Min distance between points
var k: int = 30 # Limit samples to choose before rejection
var cell_size: float = r / sqrt(2.0)
var min_cell: Vector2i
var max_cell: Vector2i
var size: int
var bounds: Rect2
var active_list: Array[Vector2] = []
var cells: Dictionary = {}
var points_list: Array[Vector2] = []
var border_points: Dictionary = {}

var rng: RandomNumberGenerator
var context_points: Dictionary
var position: Vector2

func _init(world_size: int,
		   position_ref: Vector2) -> void:
	rng = RandomNumberGenerator.new()
	position = position_ref
	size = world_size - 16
	min_cell.x = floor(position.x / cell_size)
	min_cell.y = floor(position.y / cell_size)
	max_cell.x = floor((position.x + world_size) / cell_size)
	max_cell.y = floor((position.y + world_size) / cell_size)
	points_list = generate_points()

func generate_points() -> Array[Vector2]:
	var points: Array[Vector2] = []
	var initial_sample = Vector2(rng.randf_range(position.x, position.x + size), rng.randf_range(position.y, position.y + size))
	active_list.append(initial_sample)
	cells[get_cell(initial_sample)] = initial_sample
	get_neighboring_points(get_cell(initial_sample))
	while not active_list.is_empty():
		var rand_point = active_list[rng.randi_range(0, active_list.size() - 1)]
		var point_found: bool = false
		for i in k:
			var distance = rng.randf_range(r, 2 * r)
			var angle = rng.randf_range(0, 2 * PI)
			var point = rand_point + (distance * Vector2(cos(angle), sin(angle)))
			if not check_point(point):
				continue
			var valid_distance: bool = true
			var neighbor_points = get_neighboring_points(get_cell(point))
			for point_to_check in neighbor_points:
				if point.distance_to(point_to_check) < r:
					valid_distance = false
			if valid_distance or neighbor_points.is_empty():
				point_found = true
				cells[get_cell(point)] = point
				active_list.append(point)
				points.append(point)
				break
		if not point_found:
			active_list.erase(rand_point)
	points.append(initial_sample)
	return points

func get_cell(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos / cell_size))

func check_point(pos: Vector2) -> bool:
	var is_valid: bool = true
	if pos.x < position.x or pos.x > (position.x + size):
		is_valid = false
	if pos.y < position.y or pos.y > (position.y + size):
		is_valid = false
	return is_valid

func get_neighboring_points(cell: Vector2i) -> Array[Vector2]:
	var neighbor_points: Array[Vector2] = []
	for x in range(-2, 3):
		for y in range(-2, 3):
			var offset = Vector2i(x, y)
			var cell_to_check = offset + cell
			if cells.has(cell_to_check):
				neighbor_points.append(cells[cell_to_check])
	return neighbor_points

func cell_coord(vec2: Vector2) -> Vector2i:
	return Vector2i(floor(vec2.x / cell_size), floor(vec2.x / cell_size))

func get_points() -> Array[Vector2]:
	return points_list
