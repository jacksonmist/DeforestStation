class_name Wood extends Area2D
@onready var sprite: Sprite2D = $Sprite2D

var collected: bool = false
var target: Entity
var collection_speed: float = 30
var acceleration: float = 15
@export var value: int = 1
var move_distance: float = 10
var move_time: float = 0.4
var move_tween: Tween
var ready_to_collect: bool = false

func _ready() -> void:
	if randi_range(0, 1) == 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if target and ready_to_collect:
		var direction = (target.global_position - position).normalized()
		position += (direction * delta * collection_speed)
		collection_speed += (acceleration * delta)
		if position.distance_to(target.global_position) <= 2:
			target.add_wood(value)
			queue_free()
			
func set_start_position(pos: Vector2):
	var noise = Vector2(randf_range(-5, 5), randf_range(-5, 5))
	position = pos + noise
	var rot = randf_range(0, 2 * PI)
	var vec = randf_range(move_distance / 2, move_distance) * Vector2(cos(rot), sin(rot))
	move_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	move_tween.tween_property(self, "position", position + vec, randf_range(move_time, move_time * 2))
	await move_tween.finished
	ready_to_collect = true

func _on_area_entered(body):
	if body.wood_amount >= body.max_wood:
		return
	target = body
