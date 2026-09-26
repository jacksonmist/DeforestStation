class_name SpecialJack extends Entity

@onready var state_manager: SpecialJackStateManager = $SpecialJackStateManager
var barracks: BigBarracks
var house: House

func setup(barracks_ref: BigBarracks):
	if is_setup:
		return
	is_setup = true
	barracks = barracks_ref
	state_manager.set_barracks(barracks)
	set_stats()

func set_stats():
	pass

func set_house(house_ref: House):
	house = house_ref
	state_manager.set_house(house)

func set_active(active: bool):
	can_pick_wood = active
	is_active = active
	sprite.visible = is_active
	monitoring = is_active
	monitorable = is_active

func die():
	state_manager.change_state(state_manager.states[DieState])
