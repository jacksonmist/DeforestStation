class_name Wall extends Building

@export var wall_health_scale: float = 10.0

func setup():
	can_sell = false
	can_upgrade = false
	destroyed_signal.connect(_on_destroyed)
	
func _on_destroyed():
	structure_manager.add_destroyed_wall(self)
	set_active(false)

func repair():
	structure_manager.repair_walls(self)
	return true

func set_repaired():
	AudioManager.place_repair_building_sound()
	sprite.texture = texture
	repaired_signal.emit()
	health = max_health
	update_health_bar()
	set_active(true)

func upgrade_health(house_level: int):
	max_health = base_max_health + (wall_health_scale * (house_level - 1))
	health = max_health
