class_name Barracks extends Building

@onready var heal_timer: Timer = $HealTimer

var house: Building
@export var lj_scene: PackedScene
var lumberjacks: Array[Area2D]
@export var heal_tick: float = 1
var heal_amount: float
@export var base_heal_amount: float = 1
@export var heal_increase_rate: float = 1
@export var base_lj_count: int = 3
@export var lj_increase_rate: int = 1
@export var lj_spawn_time: float = 0.5
var is_spawning: bool = false
signal finished_spawning
var healing: Array[Lumberjack]

func setup():
	create_lumberjacks(base_lj_count)
	heal_timer.timeout.connect(heal)
	heal_timer.start()

func calculate_stats():
	heal_amount = base_heal_amount + ((level - 1) * heal_increase_rate)
	
func heal():
	if healing.is_empty():
		heal_timer.start()
		return
	for jack in healing:
		jack.heal(heal_amount)
	
func create_lumberjacks(amount: int):
	var timer := Timer.new()
	timer.wait_time = lj_spawn_time
	add_child(timer)
	if is_spawning:
		await finished_spawning
	is_spawning = true
	for i in amount:
		var instance = lj_scene.instantiate()
		add_child(instance)
		instance.setup(house, self)
		lumberjacks.append(instance)
		instance.position = Vector2.ZERO
		timer.start()
		await timer.timeout
	is_spawning = false
	finished_spawning.emit()

func set_active(active: bool):
	is_active = active

func cleanup():
	for lumberjack in lumberjacks:
		lumberjack.queue_free()
	queue_free()

func set_house(house_ref: Building):
	house = house_ref

func deposit_wood(lj: Lumberjack):
	structure_manager.change_wood(lj.wood_amount)
	lj.wood_amount = 0

func start_healing(jack: Lumberjack):
	healing.append(jack)

func stop_healing(jack: Lumberjack):
	if healing.has(jack):
		healing.erase(jack)
