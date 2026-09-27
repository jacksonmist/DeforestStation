class_name UIManager extends CanvasLayer

var gm: GameManager
var sm: StructureManager
@onready var wood_amount: NinePatchRect = $WoodAmount
@onready var wood_label: Label = $WoodAmount/Label
var wood_tween: Tween

@export var semi_trans: Color
@onready var build_menu: NinePatchRect = $BuildMenu
var build_menu_start := Vector2(72.5, 181.0)
var build_menu_destination := Vector2(72.5, 147.0)
var tween_time: float = 0.5
var build_move_tween: Tween
var build_scale_tween: Tween
var structure_dict: Dictionary

@onready var barracks_button: TextureButton = $BuildMenu/BarracksButton
@onready var barracks_hint: NinePatchRect = $BuildMenu/BarracksButton/BarracksHint

@onready var watchtower_button: TextureButton = $BuildMenu/WatchtowerButton
@onready var watchtower_hint: NinePatchRect = $BuildMenu/WatchtowerButton/WatchtowerHint

@onready var bongo_button: TextureButton = $BuildMenu/BongoButton
@onready var bongo_hint: NinePatchRect = $BuildMenu/BongoButton/BongoHint

@onready var axel_button: TextureButton = $BuildMenu/AxelButton
@onready var axel_hint: NinePatchRect = $BuildMenu/AxelButton/AxelHint

@onready var boxing_ring_button: TextureButton = $BuildMenu/BoxingRingButton
@onready var box_hint: NinePatchRect = $BuildMenu/BoxingRingButton/BoxHint

@onready var big_barracks_button: TextureButton = $BuildMenu/BigBarracksButton
@onready var bb_hint: NinePatchRect = $BuildMenu/BigBarracksButton/BBHint

@onready var missile_silo_button: TextureButton = $BuildMenu/MissileSiloButton
@onready var ms_hint: NinePatchRect = $BuildMenu/MissileSiloButton/MSHint

@onready var start_button: TextureButton = $StartButton

@onready var pause_screen: Control = $PauseScreen
@onready var resume_button: TextureButton = $PauseScreen/ResumeButton
@onready var quit_button: TextureButton = $PauseScreen/QuitButton


signal unhandled_click

func _ready() -> void:
	start_button.pressed.connect(start_game)
	resume_button.pressed.connect(resume)
	quit_button.pressed.connect(quit)
	
	structure_dict = {
		sm.structures_enum.barracks: [barracks_button, barracks_hint],
		sm.structures_enum.watchtower: [watchtower_button, watchtower_hint],
		sm.structures_enum.bongo: [bongo_button, bongo_hint],
		sm.structures_enum.axel: [axel_button, axel_hint],
		sm.structures_enum.boxing_ring: [boxing_ring_button, box_hint],
		sm.structures_enum.big_barracks: [big_barracks_button, bb_hint],
		sm.structures_enum.missile_silo: [missile_silo_button, ms_hint]
	}
	build_menu.position = build_menu_start
	for structure in structure_dict.keys():
		structure_dict[structure][0].mouse_entered.connect(show_hint.bind(structure_dict[structure][1]))
		structure_dict[structure][0].mouse_exited.connect(hide_hint.bind(structure_dict[structure][1]))
		structure_dict[structure][0].pressed.connect(select_building.bind(structure))

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

func select_building(structure: StructureManager.structures_enum):
	if sm.get_selected_structure() == structure:
		sm.select_structure(sm.structures_enum.empty)
	else:
		sm.select_structure(structure)

func show_hint(hint: NinePatchRect):
	hint.visible = true

func hide_hint(hint: NinePatchRect):
	hint.visible = false

func set_wood_amount(amount: int):
	wood_label.text = str(amount)

func set_structure_manager(sm_ref: StructureManager):
	sm = sm_ref

func start_game():
	if not gm:
		return
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(start_button, "position", Vector2(113.5, 181.0), 0.5)
	gm.start_game()

func resume():
	gm.resume_game()

func quit():
	gm.quit_game()

func set_pause_menu(active: bool):
	pause_screen.visible = active

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftMouse"):
		unhandled_click.emit()

func set_game_manager(gm_ref: GameManager):
	gm = gm_ref
