class_name StructureManager extends Area2D

@export var pos_selection: Texture2D
@export var neg_selection: Texture2D
@export var neu_selection: Texture2D

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var selection: Sprite2D = $Selection
@onready var selected_structure_sprite: Sprite2D = $Selection/SelectedStructure

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
var selected_structure: PackedScene
@export var barracks: PackedScene

enum structures_enum {
	empty,
	barracks,
	watchtower
}

func _ready() -> void:
	area_entered.connect(_player_entered)
	area_exited.connect(_player_exited)
	selection.visible = false
	UiManager.set_structure_manager(self)

func _process(delta: float) -> void:
	if is_build_mode:
		var mouse_pos = get_global_mouse_position()
		mouse_cell = Vector2i(floor((mouse_pos + Vector2(8, 8)) / 16)) + Vector2i(24, 24)
		if mouse_cell in station_cells:
			selection.visible = true
			selection.position = (mouse_cell - Vector2i(24, 24)) * 16
		elif selection.visible == true:
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
		elif selected_structure and not structures.has(mouse_cell):
			add_child(cached_instance)
			cached_instance.position = (mouse_cell - Vector2i(24, 24)) * 16
			cached_instance.set_active(true)
			select_structure(structures_enum.empty)

func _player_entered(body):
	is_build_mode = true
	UiManager.show_build_menu()

func _player_exited(body):
	is_build_mode = false
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
	cached_instance = null
	match type:
		structures_enum.empty:
			selected_structure = null
		structures_enum.barracks:
			selected_structure = barracks
		structures_enum.watchtower:
			pass
	
	if selected_structure:
		cached_instance = selected_structure.instantiate()
		selected_structure_sprite.texture = cached_instance.texture
	else:
		selected_structure_sprite.texture = null

func calculate_total_wood():
	wood_amount = other_wood_amount + player_wood_amount
	UiManager.set_wood_amount(wood_amount)
	
func add_other_wood(amount: int):
	other_wood_amount += amount
	calculate_total_wood()

func update_player_wood(amount: int):
	player_wood_amount = amount
	calculate_total_wood()

func get_selected_structure() -> PackedScene:
	return selected_structure
