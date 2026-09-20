class_name Enemy extends Entity

@onready var sm: EnemyStateMachine = $EnemyStateMachine

var house: House
@export var wood_dropped: int

func set_house(house_ref: House):
	house = house_ref
	sm.set_house(house)
