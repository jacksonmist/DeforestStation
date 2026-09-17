class_name TreeObj extends Area2D

var wood: PackedScene
var tree_manager: TreeManager
@export var transparent: Color
var opaque: Color = Color.WHITE

var is_marked: bool = false
var is_active: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var health: float = 5.0
@export var respawn_time: float = 10.0

func _ready() -> void:
	timer.timeout.connect(respawn)

func _process(delta: float) -> void:
	pass

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		cut_down()

func cut_down():
	var wood_instance = wood.instantiate()
	tree_manager.add_child(wood_instance)
	wood_instance.position = position
	
	if not is_marked:
		timer.start()
		set_active(false)
	else:
		queue_free()

func respawn():
	set_active(true)

func set_active(active: bool):
	if active:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", opaque, 1)
	else:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", transparent, 1)
