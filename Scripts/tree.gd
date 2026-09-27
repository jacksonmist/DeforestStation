class_name TreeObj extends Area2D

var wood: PackedScene
var tree_manager: TreeManager
@export var transparent: Color
var opaque: Color = Color.WHITE

var is_marked: bool = false
var is_active: bool = true
var cell: Vector2i

@onready var x: Sprite2D = $X
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
@onready var label: Label = $Label
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var health: float = 5.0
var max_health: float
@export var respawn_time: float = 10.0
var index: int = 0

var respawn_tween: Tween

var damaged_tween: Tween
@export var damaged_color: Color = Color("79444a")
var damaged_time: float = 0.3

func _ready() -> void:
	max_health = health
	timer.timeout.connect(respawn)
	x.visible = false
	if randi_range(0, 1) == 0:
		x.flip_h = false
	else:
		x.flip_h = true
	if randi_range(0, 1) == 0:
		x.flip_v = false
	else:
		x.flip_v = true
	if cell:
		label.text = str(cell)

func take_damage(amount: float):
	if not is_active:
		return
	health -= amount
	if damaged_tween and damaged_tween.is_running():
		damaged_tween.kill()
	damaged_tween = create_tween()
	damaged_tween.tween_property(self, "modulate", damaged_color, damaged_time / 2)
	damaged_tween.tween_property(self, "modulate", Color.WHITE, damaged_time / 2)
	if health <= 0:
		cut_down()

func cut_down():
	if respawn_tween:
		respawn_tween.kill()
	var wood_instance = wood.instantiate()
	tree_manager.add_child(wood_instance)
	wood_instance.set_start_position(position)
	
	if not is_marked:
		timer.start()
		set_active(false)
	else:
		tree_manager.remove_marked(self)
		tree_manager.remove_from_dict(self)
		queue_free()

func respawn():
	set_active(true)
	health = max_health

func set_active(active: bool):
	is_active = active
	if active:
		respawn_tween = create_tween()
		respawn_tween.tween_property(sprite, "modulate", opaque, 0.5)
		collision.disabled = false
	else:
		collision.disabled = true
		sprite.modulate = transparent

func set_cell(cell_ref: Vector2i):
	cell = cell_ref

func mark_tree():
	is_marked = true
	x.visible = true
	if not is_active:
		queue_free()
