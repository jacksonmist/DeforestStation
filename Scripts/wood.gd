class_name Wood extends Area2D

var collected: bool = false
var target: Entity
var collection_speed: float = 20
@export var value: int = 1

func _process(delta: float) -> void:
	if target:
		var direction = (target.position - position).normalized()
		position += (direction * delta * collection_speed)
		if position.distance_to(target.position) <= 2:
			target.add_wood(value)
			queue_free()

func collect(body: Entity):
	target = body
