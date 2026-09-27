class_name BuildingMenu extends NinePatchRect

@onready var upgrade: TextureButton = $Control/Upgrade
@onready var sell: TextureButton = $Control/Sell
@onready var repair: TextureButton = $Control/Repair

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
	parent.damaged.connect(show_repair)
	parent.clicked.connect(on_clicked)
	parent.max_level_reached.connect(disable_upgrade)
	parent.structure_manager.exited_build.connect(hide_menu)
	parent.structure_manager.entered_build.connect(set_can_click.bind(true))
	parent.structure_manager.exited_build.connect(set_can_click.bind(false))
	upgrade.pressed.connect(try_upgrade_level)
	repair.pressed.connect(try_repair)
	parent.prices_changed.connect(set_labels)
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
	upgrade.visible = true if parent.can_upgrade else false
	var is_max_health = parent.health == parent.max_health
	repair.visible = false if is_max_health else true
	if not sell.visible and not upgrade.visible and not repair.visible:
		return
	set_labels()
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

func set_labels():
	var amount = parent.structure_manager.wood_amount
	var u_cost = parent.current_upgrade_cost
	var r_cost = parent.repair_cost
	var s_amt = parent.sell_amount
	upgrade_cost.text = "-" + str(u_cost)
	upgrade_cost.modulate = can_afford_color if u_cost <= amount else cant_afford_color
	repair_cost.text = "-" + str(r_cost)
	repair_cost.modulate = can_afford_color if r_cost <= amount else cant_afford_color
	sell_cost.text = "+" + str(s_amt)

func check_tween():
	if move_tween and move_tween.is_running():
		move_tween.kill()
	if scale_tween and scale_tween.is_running():
		scale_tween.kill()

func try_upgrade_level():
	parent.upgrade_level()

func show_repair():
	repair.visible = true

func try_repair():
	if parent.repair():
		repair.visible = false

func try_sell():
	parent.sell()

func disable_upgrade():
	pass
