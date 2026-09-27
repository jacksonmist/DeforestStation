class_name TreeManager extends Node

@export var wood: PackedScene
@export var tree_scene: PackedScene
@export var grid_manager: GridManager
@export var house: House
var tree_dict: Dictionary
var marked_trees: Array

func place_trees(points: Array[Vector2]):
	var house_cell = Vector2i(24, 24)
	for point in points:
		var tree = tree_scene.instantiate()
		add_child(tree)
		tree.position = point
		tree.tree_manager = self
		tree.wood = wood
		var tree_cell := Vector2i(round(point/16)) + Vector2i(24, 24)
		var dir_to_house = Vector2i(Vector2(house_cell - tree_cell).normalized().round())
		tree_cell += dir_to_house
		tree.set_cell(tree_cell)
		var distance_to_house = tree_cell.distance_to(house_cell)
		if distance_to_house <= house.starting_radius + 0.25:
			tree.queue_free()
			continue
		if not tree_dict.has(tree_cell):
			tree_dict[tree_cell] = [tree]
		else:
			var idx: int = 0
			for x in tree_dict[tree_cell]:
				idx += 1
			tree_dict[tree_cell].append(tree)
			tree.index = idx

func check_occupied(cells: Array[Vector2i]):
	marked_trees = []
	var occupied: bool = false
	for cell in cells:
		if tree_dict.has(cell):
			occupied = true
			for tree in tree_dict[cell]:
				tree.mark_tree()
				marked_trees.append(tree)
	return occupied

func remove_marked(tree):
	for marked in marked_trees:
		if not is_instance_valid(marked):
			marked_trees.erase(marked)

	if marked_trees.has(tree):
		marked_trees.erase(tree)
	else:
		print("Marked tree not found in array")
	if marked_trees.is_empty():
		grid_manager.no_marked_trees()

func remove_from_dict(tree: TreeObj):
	tree_dict[tree.cell][tree.index] = null
	if tree_dict[tree.cell].is_empty():
		tree_dict.erase(tree.cell)
	var all_null: bool = true
	for tr in tree_dict[tree.cell]:
		if tr:
			all_null = false
	if all_null:
		tree_dict.erase(tree.cell)
