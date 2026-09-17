class_name Ground extends Sprite2D

@export var cell_by_cell: Vector2 = Vector2(49, 49)
var target_size: Vector2

func _ready() -> void:
	target_size = Vector2(cell_by_cell * 16)
	scale = target_size / texture.get_size()
