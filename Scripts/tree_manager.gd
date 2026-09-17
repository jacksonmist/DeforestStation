class_name TreeManager extends Node

@export var wood: PackedScene
@export var tree_scene: PackedScene
@export var grid_manager: GridManager
@export var house: House

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func place_trees(points: Array[Vector2]):
	for point in points:
		var tree = tree_scene.instantiate()
		add_child(tree)
		tree.position = point
		tree.tree_manager = self
		tree.wood = wood
		var tree_cell := Vector2i(floor(point/16))
		var distance_to_house = tree_cell.distance_to(house.cell)
		if distance_to_house <= house.starting_radius * 3:
			tree.queue_free()
