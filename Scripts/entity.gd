class_name Entity extends Area2D

@export var health: float = 10.0
@export var speed: float = 20.0
@export var aps: float = 1.0
@export var damage: float = 5.0
@export var atk_range: float = 8.0
var can_attack: bool = true
var attack_cooldown: float = 1.0
var timer: Timer

var wood_amount: int

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
	for child in get_children():
		if child.has_method("setup"):
			child.setup(self)
	timer = Timer.new()
	timer.wait_time = attack_cooldown
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	timer.timeout.connect(timeout)

func _process(delta: float) -> void:
	if not imm_targets.is_empty():
		attack()
	if move_direction == Vector2.ZERO:
		return
	position += (move_direction * speed * delta)

func attack():
	if not can_attack:
		return
	var target = imm_targets[0]
	if target.has_method("take_damage"):
		target.take_damage(damage)
		can_attack = false
		timer.start()
	
func take_damage(amount: float):
	health -= amount
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
