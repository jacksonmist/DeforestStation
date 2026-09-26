class_name SpecialJackStateManager extends Node

var parent: Entity
@export var initial_state: State
var states: Dictionary = {}

var current_state: State
var barracks: Building
var house: House

var last_target: Entity = null

func setup(parent_ref: Entity) -> void:
	states = {
	}
	pass
	#parent = parent_ref
	#if not initial_state: change_state(states[IdleState])
	#
	#for state in states.values():
		#state.setup(parent, self)
	
func change_state(new_state: State) -> void:
	if current_state == new_state: return
	if not current_state and not new_state: return
	if current_state and not new_state: return
	if not parent.is_active: return
	
	if current_state:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state()

func _physics_process(delta: float) -> void:
	if not current_state: return
	
	current_state.update(delta)

func set_barracks(barracks_ref: Building) -> void:
	barracks = barracks_ref
	for state in states.values():
		state.barracks = barracks

func set_house(house_ref: House):
	house = house_ref
	for state in states.values():
		state.house = house
