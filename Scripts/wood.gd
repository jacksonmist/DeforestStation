class_name Wood extends Area2D
@onready var sprite: Sprite2D = $Sprite2D

var collected: bool = false
var target: Entity
var collection_speed: float = 30
var acceleration: float = 15
@export var value: int = 1

func _ready() -> void:
	if randi_range(0, 1) == 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _process(delta: float) -> void:
	if target:
		var direction = (target.position - position).normalized()
		position += (direction * delta * collection_speed)
		collection_speed += (acceleration * delta)
		if position.distance_to(target.position) <= 2:
			target.add_wood(value)
			queue_free()

func collect(body: Entity):
	target = body
