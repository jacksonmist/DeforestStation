class_name Wall extends Building

func setup():
	destroyed_signal.connect(_on_destroyed)
	
func _on_destroyed():
	structure_manager.add_destroyed_wall(self)

func try_repair():
	structure_manager.repair_walls(self)

func repair():
	sprite.texture = texture
	repaired_signal.emit()
	health = max_health
	set_active(true)
