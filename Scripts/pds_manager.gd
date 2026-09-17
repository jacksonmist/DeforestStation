class_name PDSManager extends Node

var pds : PoissonDiscSampler
@export var ground_map: GroundMap
@export var tree_manager: TreeManager
var points: Array[Vector2]

func generate_points(world_size):
	var position_offset = ground_map.position_offest
	pds = PoissonDiscSampler.new(world_size * 16, -position_offset)
	points = pds.get_points()
	tree_manager.place_trees(points)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
