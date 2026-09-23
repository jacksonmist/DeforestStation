class_name Lumberjack extends Entity

@onready var state_manager: LumberjackStateManager = $LumberjackStateManager
var house: House
var barracks: Barracks
@export var wood: PackedScene

func setup(house_ref: House, barracks_ref: Barracks):
	house = house_ref
	state_manager.set_house(house)
	barracks = barracks_ref
	state_manager.set_barracks(barracks)
	area_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_exited)
	
func _on_body_entered(body):
	if not dis_targets.has(body):
		dis_targets.append(body)

func _on_body_exited(body):
	if dis_targets.has(body):
		dis_targets.erase(body)

func set_active(active: bool):
	can_pick_wood = active
	is_active = active
	sprite.visible = is_active
	monitoring = is_active
	monitorable = is_active

func drop_wood():
	can_pick_wood = false
	for i in wood_amount:
		var instance = wood.instantiate()
		barracks.structure_manager.add_child(instance)
		instance.set_start_position(global_position)
	wood_amount = 0

func die():
	state_manager.change_state(state_manager.states[DieState])
