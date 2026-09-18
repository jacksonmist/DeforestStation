class_name TreeManager extends Node

@export var wood: PackedScene
@export var tree_scene: PackedScene
@export var grid_manager: GridManager
@export var house: House
var tree_dict: Dictionary
var marked_trees: Array

func place_trees(points: Array[Vector2]):
	for point in points:
		var tree = tree_scene.instantiate()
		add_child(tree)
		tree.position = point
		tree.tree_manager = self
		tree.wood = wood
		var tree_cell := Vector2i(floor(point/16))
		tree.position = tree_cell * 16
		tree.set_cell(tree_cell)
		tree_cell += Vector2i(24, 24)
		var distance_to_house = tree_cell.distance_to(house.cell + Vector2i(24, 24))
		if distance_to_house <= house.starting_radius:
			tree.queue_free()
			continue
		if not tree_dict.has(tree_cell):
			tree_dict[tree_cell] = tree
		else:
			tree.queue_free()

func check_occupied(cells: Array[Vector2i]):
	marked_trees = []
	var occupied: bool = false
	for cell in cells:
		if tree_dict.has(cell):
			occupied = true
			var tree = tree_dict[cell]
			tree.mark_tree()
			marked_trees.append(tree)
	return occupied

func remove_marked(tree):
	if marked_trees.has(tree):
		marked_trees.erase(tree)
	else:
		print("Marked tree not found in array")
	if marked_trees.is_empty():
		grid_manager.no_marked_trees()
	print(marked_trees)
