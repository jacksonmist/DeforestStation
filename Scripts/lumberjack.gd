class_name Lumberjack extends Entity

@onready var state_manager: LumberjackStateManager = $LumberjackStateManager
var house: House
var barracks: Barracks
@onready var sprite: Sprite2D = $Sprite2D

func setup(house_ref: House, barracks_ref: Barracks):
	house = house_ref
	state_manager.set_house(house)
	barracks = barracks_ref
	state_manager.set_barracks(barracks)
	area_entered.connect(_on_body_entered)
	area_entered.connect(_on_body_exited)
	
func _on_body_entered(body):
	if not dis_targets.has(body):
		dis_targets.append(body)

func _on_body_exited(body):
	if dis_targets.has(body):
		dis_targets.erase(body)

func set_active(active: bool):
	is_active = active
	sprite.visible = is_active
	monitoring = is_active
	monitorable = is_active
