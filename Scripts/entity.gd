class_name Entity extends Area2D
@onready var sprite: Sprite2D = $Sprite2D

@export var max_health: float = 10.0
var health: float
@export var speed: float = 20.0
@export var aps: float = 1.0
@export var damage: float = 5.0
@export var atk_range: float = 8.0
var can_attack: bool = true
var attack_cooldown: float = 1.0
var chosen_target
var timer: Timer
var is_active: bool = false
var low_health_factor: float = 0.33
var is_low_health: bool = false
var walk_time: float = 0

var wood_amount: int
@export var starting_max_wood: int = 5
var max_wood: int = INF

var walk_rotation: float = PI / 5
var walk_height: float = 4
var walk_width: float = 4
var base_walk_speed: float = 0.3
var position_tween_y: Tween
var rotation_tween: Tween
var x_dir: int = 0

var damaged_tween: Tween
@export var damaged_color: Color = Color("79444a")
var damaged_time: float = 0.3

enum allegience {
	friendly,
	enemy
}

@export var entity_allegience: allegience

var dis_targets: Array[Node2D]
var imm_targets: Array[Node2D]

var target_list: Array[Node2D]

var move_direction := Vector2.ZERO

func _ready() -> void:
	is_active = true
	health = max_health
	max_wood = starting_max_wood
	for child in get_children():
		if child.has_method("setup"):
			child.setup(self)
	timer = Timer.new()
	update_attack_cooldown()
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.timeout.connect(timeout)

func _process(delta: float) -> void:
	if not imm_targets.is_empty():
		attack()
	if move_direction == Vector2.ZERO:
		x_dir = 0
		walk_time = 0
		if not rotation_tween and sprite.rotation != 0:
			rotation_tween = create_tween().set_parallel(true)
			rotation_tween.tween_property(sprite, "rotation", 0, 0.1)
		if not position_tween_y and sprite.position != Vector2.ZERO:
			position_tween_y = create_tween().set_parallel(true)
			position_tween_y.tween_property(sprite, "position", Vector2.ZERO, 0.1)
		return
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = null
	if position_tween_y:
		position_tween_y.kill()
	position_tween_y = null
	position += (move_direction * speed * delta)
	walk_time += delta
	if x_dir == 0:
		x_dir = 1 if move_direction.x >= 0 else -1
	sprite.position.x = x_dir * (walk_width * sin(walk_time * base_walk_speed * speed))
	sprite.position.y = -(walk_height * sin(walk_time * base_walk_speed * speed) ** 2)
	sprite.rotation = x_dir * (walk_rotation * sin(walk_time * base_walk_speed * speed))

func attack():
	if not can_attack:
		return
	for target in imm_targets:
		if chosen_target and imm_targets.has(chosen_target):
			break
		if target.has_method("set_active") and target.is_active:
			chosen_target = target
	if chosen_target and chosen_target.has_method("take_damage"):
		chosen_target.take_damage(damage)
		can_attack = false
		timer.start()
	
func take_damage(amount: float):
	health -= amount
	if damaged_tween and damaged_tween.is_running():
		damaged_tween.kill()
	damaged_tween = create_tween()
	damaged_tween.tween_property(self, "modulate", damaged_color, damaged_time / 2)
	damaged_tween.tween_property(self, "modulate", Color.WHITE, damaged_time / 2)
	if health / max_health < low_health_factor:
		is_low_health = true
	if health <= 0:
		health = 0
		die()

func die():
	pass
	
func move(direction: Vector2):
	move_direction = direction

func update_immediate_targets(targets: Array[Node2D]):
	imm_targets = targets

func update_attack_cooldown():
	attack_cooldown = 1 / aps
	timer.wait_time = attack_cooldown

func timeout():
	can_attack = true

func add_wood(amount: int):
	wood_amount += amount

func heal(amount: float):
	health += amount
	if health >= max_health:
		health = max_health

func set_active(active: bool):
	is_active = active
