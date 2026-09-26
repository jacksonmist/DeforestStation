class_name BigBarracks extends Building

@export var remaining_jacks: Array[PackedScene]
var jacks: Array[SpecialJack]
var house: House
func setup():
	house = structure_manager.house
	spawn_jack()
	
func calculate_stats():
	spawn_jack()

func spawn_jack():	
	var chosen_jack = remaining_jacks.pop_at(randi_range(0, remaining_jacks.size() - 1))
	if not chosen_jack:
		return
	var instance = chosen_jack.instantiate()
	add_child(instance)
	instance.set_house(house)
	instance.setup(self)
	jacks.append(instance)
	instance.position = Vector2.ZERO
