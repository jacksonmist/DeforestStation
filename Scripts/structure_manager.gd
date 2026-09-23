class_name StructureManager extends Area2D

@export var pos_selection: Texture2D
@export var neg_selection: Texture2D
@export var neu_selection: Texture2D

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var external_sprite: Sprite2D = $ExternalSprite
@onready var selection: Sprite2D = $Selection
@onready var selected_structure_sprite: Sprite2D = $Selection/SelectedStructure

var external_sprite_offset := Vector2(8, -16)

var station_cells: Dictionary
var structures: Dictionary
var radius: float
var is_build_mode: bool = false
var house: Building

var player_wood_amount: int
var other_wood_amount: int
var wood_amount: int

var mouse_cell: Vector2i

var cached_instance: Area2D
var selected_structure: structures_enum
@export var barracks: PackedScene
@export var watchtower: PackedScene

var shown_building_menu: BuildingMenu

var destroyed_walls: Array[Wall]

signal entered_build
signal exited_build

enum structures_enum {
	empty,
	barracks,
	watchtower
}
var structure_dict: Dictionary

func _ready() -> void:
	set_structure_dict()
	area_entered.connect(_player_entered)
	area_exited.connect(_player_exited)
	selection.visible = false
	UiManager.set_structure_manager(self)
	wood_amount = 0
	UiManager.set_wood_amount(wood_amount)
	UiManager.unhandled_click.connect(unhandled_click)

func set_structure_dict():
	structure_dict = {
		structures_enum.empty: null,
		structures_enum.barracks: barracks,
		structures_enum.watchtower: watchtower
	}

func _process(delta: float) -> void:
	if is_build_mode:
		var mouse_pos = get_global_mouse_position()
		mouse_cell = Vector2i(floor((mouse_pos + Vector2(8, 8)) / 16)) + Vector2i(24, 24)
		if mouse_cell in station_cells:
			external_sprite.visible = false
			selection.visible = true
			selection.position = (mouse_cell - Vector2i(24, 24)) * 16
		else:
			external_sprite.visible = true
			external_sprite.position = mouse_pos + external_sprite_offset
			if selection.visible == true:
				selection.visible = false
		if not selected_structure:
			selection.texture = neu_selection
			return
		if mouse_cell in structures:
			selection.texture = neg_selection
		else:
			selection.texture = pos_selection

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LeftMouse"):
		if not selected_structure and structures.has(mouse_cell):
			var clicked_building = structures[mouse_cell]
		elif selected_structure and not structures.has(mouse_cell) and station_cells.has(mouse_cell):
			add_child(cached_instance)
			var cell = mouse_cell
			cached_instance.position = (cell - Vector2i(24, 24)) * 16
			cached_instance.set_active(true)
			structures[cell] = cached_instance
			change_wood(-cached_instance.purchase_cost)
			cached_instance.building_placed()
			cached_instance.set_origin(cell)
			cached_instance = null
			select_structure(structures_enum.empty)
			external_sprite.texture = null

func _player_entered(body):
	is_build_mode = true
	entered_build.emit()
	UiManager.show_build_menu()

func _player_exited(body):
	is_build_mode = false
	exited_build.emit()
	selection.visible = false
	set_shown_building_menu(null)
	UiManager.hide_build_menu()

func update_radius(amount: float):
	radius = amount * 16
	shape.shape.radius = radius

func set_house(house_ref: Building):
	house = house_ref
	structures[house.cell] = house

func update_station_cells(dict_ref: Dictionary):
	station_cells = dict_ref

func select_structure(type: structures_enum):
	if cached_instance:
		cached_instance.queue_free()
	external_sprite.texture = null
	cached_instance = null
	match type:
		structures_enum.empty:
			selected_structure = structures_enum.empty
		structures_enum.barracks:
			selected_structure = structures_enum.barracks
		structures_enum.watchtower:
			selected_structure = structures_enum.watchtower
	
	if selected_structure:
		cached_instance = structure_dict[selected_structure].instantiate()
		if cached_instance.purchase_cost > wood_amount:
			cached_instance.cleanup()
			cached_instance = null
			selected_structure = structures_enum.empty
			return
		selected_structure_sprite.texture = cached_instance.texture
		cached_instance.set_structure_manager(self)
		external_sprite.texture = cached_instance.texture
	else:
		selected_structure_sprite.texture = null

func change_wood(amount: int):
	wood_amount += amount
	UiManager.set_wood_amount(wood_amount)

func get_selected_structure() -> structures_enum:
	return selected_structure

func set_shown_building_menu(menu: BuildingMenu):
	if shown_building_menu and shown_building_menu != menu:
		shown_building_menu.hide_menu()
	shown_building_menu = menu

func sell_building(building_cells: Array[Vector2i]):
	var origin = building_cells[0]
	if not structures[origin].can_sell:
		return
	change_wood(int(ceil(float(structures[origin].purchase_cost) / 2)))
	structures[origin].cleanup()
	for cell in building_cells:
		structures.erase(cell)

func unhandled_click():
	pass

func add_destroyed_wall(wall_to_add: Wall):
	if not destroyed_walls.has(wall_to_add):
		destroyed_walls.append(wall_to_add)

func repair_walls(first_wall: Wall):
	if first_wall in destroyed_walls:
		if first_wall.repair_cost <= wood_amount:
			change_wood(first_wall.repair_cost)
			first_wall.repair()
	for wall in destroyed_walls:
		if wall.repair_cost > wood_amount:
			return
		change_wood(wall.repair_cost)
		wall.repair()
