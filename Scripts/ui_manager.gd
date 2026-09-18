class_name UIManager extends CanvasLayer

var sm: StructureManager
@onready var wood_amount: NinePatchRect = $WoodAmount
@onready var wood_label: Label = $WoodAmount/Label
var wood_tween: Tween

@export var semi_trans: Color
@onready var build_menu: NinePatchRect = $BuildMenu
var build_menu_start := Vector2(139.0, 673.0)
var build_menu_destination := Vector2(139.0, 544.0)
var tween_time: float = 0.5
var build_move_tween: Tween
var build_scale_tween: Tween

@onready var barracks_button: Button = $BuildMenu/SpriteContainer/BarracksButton
@onready var barracks_hint: NinePatchRect = $BuildMenu/SpriteContainer/BarracksHint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_menu.position = build_menu_start
	barracks_button.mouse_entered.connect(show_barracks_hint)
	barracks_button.mouse_exited.connect(hide_barracks_hint)
	barracks_button.pressed.connect(select_barracks)

func _process(delta: float) -> void:
	pass

func check_tween():
	if build_move_tween and build_move_tween.is_running():
		build_move_tween.kill()
	if build_scale_tween and build_scale_tween.is_running():
		build_scale_tween.kill()

func show_build_menu():
	check_tween()
	build_move_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	build_scale_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	wood_tween = create_tween().set_parallel(true)
	build_move_tween.tween_property(build_menu, "position", build_menu_destination, tween_time)
	build_scale_tween.tween_property(build_menu, "scale", Vector2(1, 1), tween_time)
	wood_tween.tween_property(wood_amount, "modulate", Color.WHITE, tween_time)
	
func hide_build_menu():
	check_tween()
	build_move_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	build_scale_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_ELASTIC)
	wood_tween = create_tween().set_parallel(true)
	build_move_tween.tween_property(build_menu, "position", build_menu_start, tween_time)
	build_scale_tween.tween_property(build_menu, "scale", Vector2.ZERO, tween_time)
	wood_tween.tween_property(wood_amount, "modulate", semi_trans, tween_time)
	sm.select_structure(sm.structures_enum.empty)

func select_barracks():
	if sm.get_selected_structure() == sm.barracks:
		sm.select_structure(sm.structures_enum.empty)
	else:
		sm.select_structure(sm.structures_enum.barracks)

func show_barracks_hint():
	barracks_hint.visible = true

func hide_barracks_hint():
	barracks_hint.visible = false

func set_wood_amount(amount: int):
	wood_label.text = str(amount)

func set_structure_manager(sm_ref: StructureManager):
	sm = sm_ref
