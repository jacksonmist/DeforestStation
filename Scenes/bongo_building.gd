class_name Bongo extends Building

@onready var timer: Timer = $Timer
@onready var anim_timer: Timer = $AnimTimer

var base_texture: Texture
@export var anim1: Texture
@export var anim2: Texture

var heal_amount: float
@export var base_heal_amount: float = 1
@export var heal_amount_increase: float = 1
var heal_timer: float
@export var base_heal_timer: float = 5
@export var heal_timer_decrease: float = 0.5

var is_repairing: bool = false

var adjacent_buildings: Array[Building]
var adjacent_offsets = [Vector2i(1, 0), Vector2i(0, 1),
						Vector2i(-1, 0), Vector2i(0, -1)]

func setup():
	calculate_stats()
	base_texture = sprite.texture
	update_adjacent_buildings()
	timer.timeout.connect(repair_loop)
	anim_timer.timeout.connect(progress_anim)
	repaired_signal.connect(update_adjacent_buildings)

func calculate_stats():
	heal_amount = base_heal_amount + (heal_amount_increase * (level - 1))
	heal_timer = base_heal_timer - (heal_timer_decrease * (level - 1))
	timer.wait_time = heal_timer

func update_adjacent_buildings():
	for offset in adjacent_offsets:
		var adj_building = structure_manager.get_building_at_cell(origin + offset)
		if adj_building:
			adjacent_buildings.append(adj_building)
			adj_building.damaged.connect(start_repairing)
			if adj_building.health < adj_building.max_health:
				start_repairing()

func start_repairing():
	if is_repairing:
		return
	is_repairing = true
	repair_loop()
	
func repair_loop():
	if not is_repairing or not is_active:
		is_repairing = false
		return
	var all_repaired: bool = true
	for building in adjacent_buildings:
		building.heal(heal_amount)
		if building.health != max_health:
			all_repaired = false
	if all_repaired:
		is_repairing = false
		start_stop_anim(false)
		return
	timer.start()
	start_stop_anim(true)

func start_stop_anim(active: bool):
	if not active:
		sprite.texture = base_texture
		anim_timer.stop()
		return
	progress_anim()
	
func progress_anim():
	match sprite.texture:
		base_texture:
			sprite.texture = anim1
		anim1:
			sprite.texture = anim2
		anim2:
			sprite.texture = anim1
	anim_timer.start()
