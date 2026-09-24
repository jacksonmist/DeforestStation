class_name Wall extends Building

func setup():
	can_sell = false
	can_upgrade = false
	destroyed_signal.connect(_on_destroyed)
	
func _on_destroyed():
	structure_manager.add_destroyed_wall(self)
	set_active(false)

func repair():
	structure_manager.repair_walls(self)

func set_repaired():
	sprite.texture = texture
	repaired_signal.emit()
	health = max_health
	set_active(true)
