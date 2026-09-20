class_name Enemy extends Entity

@onready var sm: EnemyStateMachine = $EnemyStateMachine

var house: House
@export var wood_dropped: int
var wood: PackedScene
var enemy_manager: EnemyManager

func set_manager(em: EnemyManager):
	enemy_manager = em

func set_house(house_ref: House):
	house = house_ref
	sm.set_house(house)

func set_wood(wood_ref: PackedScene):
	wood = wood_ref

func die():
	for i in wood_dropped:
		var instance = wood.instantiate()
		enemy_manager.add_child(instance)
		instance.set_start_position(position)
	queue_free()
