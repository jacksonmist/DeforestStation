class_name Enemy extends Entity

@onready var sm: EnemyStateMachine = $EnemyStateMachine

var house: House
@export var wood_dropped: int
var wood: PackedScene
var enemy_manager: EnemyManager

func take_damage(amount: float):
	health -= amount
	AudioManager.play_wood_cut_sound()
	if damaged_tween and damaged_tween.is_running():
		damaged_tween.kill()
	damaged_tween = create_tween()
	damaged_tween.tween_property(self, "modulate", damaged_color, damaged_time / 2)
	damaged_tween.tween_property(self, "modulate", Color.WHITE, damaged_time / 2)
	if health / max_health < low_health_factor:
		is_low_health = true
	if health <= 0:
		health = 0
		die()

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
		enemy_manager.call_deferred("add_child", instance)
		instance.set_start_position(position)
	queue_free()
