class_name BuildingMenu extends NinePatchRect

@onready var upgrade: TextureButton = $Control/Upgrade
@onready var sell: TextureButton = $Control/Sell

@export var can_afford_color: Color = Color("abff7a")
@export var cant_afford_color: Color = Color("ff7a7a")

@onready var upgrade_cost: Label = $Control/Upgrade/Cost
@onready var repair_cost: Label = $Control/Repair/Cost
@onready var sell_cost: Label = $Control/Sell/Cost


var parent: Building
var is_showing: bool = false
var can_click: bool = true

var start_pos: Vector2
var end_pos: Vector2

var move_tween: Tween
var scale_tween: Tween
var tween_time: float = 0.5

func setup(parent_ref: Building):
	if not parent_ref.structure_manager:
		visible = false
		return
	parent = parent_ref
	end_pos = position
	start_pos = parent.position
	position = start_pos
	scale = Vector2.ZERO
	visible = false
	parent.clicked.connect(on_clicked)
	parent.max_level_reached.connect(disable_upgrade)
	parent.structure_manager.exited_build.connect(hide_menu)
	parent.structure_manager.entered_build.connect(set_can_click.bind(true))
	parent.structure_manager.exited_build.connect(set_can_click.bind(false))
	upgrade.pressed.connect(try_upgrade_level)
	
	if not parent.can_sell:
		sell.visible = false
	else:
		sell.pressed.connect(try_sell)
	
func on_clicked():
	if not can_click:
		return
	if not is_showing:
		show_menu()
	else:
		hide_menu()

func set_can_click(value: bool):
	can_click = value

func show_menu():
	check_tween()
	sell.visible = true if parent.can_sell else false
	parent.structure_manager.set_shown_building_menu(self)
	is_showing = true
	visible = true
	move_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	scale_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	move_tween.tween_property(self, "position", end_pos, tween_time)
	scale_tween.tween_property(self, "scale", Vector2(1, 1), tween_time)

func hide_menu():
	check_tween()
	is_showing = false
	move_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	scale_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	move_tween.tween_property(self, "position", start_pos, tween_time)
	scale_tween.tween_property(self, "scale", Vector2.ZERO, tween_time)
	await move_tween.finished
	visible = false

func check_tween():
	if move_tween and move_tween.is_running():
		move_tween.kill()
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()

func try_upgrade_level():
	parent.upgrade_level()

func try_sell():
	parent.sell()

func disable_upgrade():
	pass
