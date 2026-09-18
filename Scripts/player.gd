class_name Player extends Entity

@export var house: House
@export var structure_manager: StructureManager

func _input(event: InputEvent) -> void:
	var move_vector = Input.get_vector("Left", "Right", "Up", "Down")
	move(move_vector)

func _ready() -> void:
	super()
	area_entered.connect(_on_area_entered)
	wood_amount = 0
	structure_manager.update_player_wood(wood_amount)

func _on_area_entered(body):
	if body is Wood:
		body.collect(self)

func add_wood(amount: int):
	wood_amount += amount
	structure_manager.update_player_wood(wood_amount)
