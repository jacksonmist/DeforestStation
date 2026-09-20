class_name EnemyManager extends Node
@onready var timer: Timer = $Timer
@onready var spawn_space: Timer = $SpawnSpace

@export var enemy_scenes: Array[PackedScene]

@export var difficulty_manager: DifficultyManager
@export var tree_manager: TreeManager
@export var house: House
@export var wood: PackedScene

@export var base_amount_to_spawn: int = 5
var spawn_amount_modifier: float = 1
@export var spawn_delay: float = 10
var current_dificulty: float

var active_enemies: Array[Enemy]

func _ready() -> void:
	timer.wait_time = spawn_delay
	spawn_enemy()

func spawn_enemy():
	var amount_to_spawn = base_amount_to_spawn * spawn_amount_modifier
	var max = enemy_scenes.size() - 1
	for i in amount_to_spawn:
		var rand = randf()
		var idx = int(round(rand * max))
		var instance = enemy_scenes[idx].instantiate()
		var position = get_position()
		add_child(instance)
		instance.set_house(house)
		instance.set_wood(wood)
		instance.set_manager(self)
		active_enemies.append(instance)
		instance.position = position
		spawn_space.start()
		await spawn_space.timeout
	timer.wait_time = spawn_delay
	timer.start()

func get_position() -> Vector2:
	return  tree_manager.tree_dict.values().pick_random()[0].position
