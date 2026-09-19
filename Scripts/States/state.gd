@abstract
class_name State extends Resource

var parent: Entity
var sm: LumberjackStateManager
var house: Building
var barracks: Barracks

func setup(parent_ref: Entity, state_machine_ref: LumberjackStateManager):
	parent = parent_ref
	sm = state_machine_ref

func enter_state() ->  void:
	pass
	
func exit_state() -> void:
	pass

func update(_delta: float) -> void:
	pass
