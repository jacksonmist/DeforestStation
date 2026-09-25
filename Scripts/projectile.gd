class_name Projectile extends Area2D

var direction: Vector2
var knockback: float
var speed: float
var damage: float
var time_active: float
var timer: Timer

func setup(direction_val: Vector2, speed_val: float, damage_val: float, time_val: float, knockback_val: float):
	direction = direction_val
	rotation = direction.angle()
	speed = speed_val
	damage = damage_val
	knockback = knockback_val
	time_active = time_val
	timer = Timer.new()
	timer.wait_time = time_active
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(timeout)
	area_entered.connect(enemy_hit)

func _process(delta: float) -> void:
	if not direction or not speed:
		return
	position += (direction * speed * delta)

func enemy_hit(body):
	if body and body.has_method("take_damage") and body.is_active:
		body.take_damage(damage)
		queue_free()

func timeout():
	queue_free()
