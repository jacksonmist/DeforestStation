class_name Missile extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var rocket: CPUParticles2D = $Sprite2D/Rocket
@onready var explosion: CPUParticles2D = $Explosion


var target_pos: Vector2
var launch_tween: Tween
var target_list: Array
var is_launched: bool = false
var detonated: bool = false
var speed: float = 30
var travel_time: float
var time: float = 0
var height: float = 100
var direction: Vector2
var prev_pos: Vector2

var damage: float
var atk_range: float

func launch_sequence(pos: Vector2, damage_val: float, atk_range_val: float):
	damage = damage_val
	atk_range = atk_range_val
	area_entered.connect(add_target)
	area_exited.connect(remove_target)
	set_range()
	var vec_to_pos = pos - global_position
	prev_pos = global_position
	var distance = vec_to_pos.length()
	direction = vec_to_pos.normalized()
	
	travel_time = distance / speed
	target_pos = pos
	launch_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	launch_tween.tween_property(self, "position", Vector2(16, -16), 1)
	await launch_tween.finished
	is_launched = true
	var rot_tween = create_tween()
	var rot_tgt: float = 1 if direction.x >= 0 else -1
	rot_tween.tween_property(sprite, "rotation_degrees", rot_tgt * 180, travel_time)
	rocket.emitting = true
	timer.wait_time = travel_time
	timer.timeout.connect(detonate)
	timer.start()

func _process(delta: float) -> void:
	if not is_launched or detonated:
		return
	time += delta
	var t: float = clamp(time / travel_time, 0.0, 1.0)
	sprite.position.y = -sin(t * PI) * height
	position += (direction * speed * delta)

func set_range():
	await ready
	collision.shape.radius = atk_range

func detonate():
	detonated = true
	rocket.emitting = false
	explosion.emitting = true
	for target in target_list:
		if target and target.is_active:
			target.take_damage(damage)
	await explosion.finished
	queue_free()

func add_target(body):
	if not target_list.has(body):
		target_list.append(body)

func remove_target(body):
	if target_list.has(body):
		target_list.erase(body)
