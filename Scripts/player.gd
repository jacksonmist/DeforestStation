class_name Player extends Entity

@export var house: House
@export var structure_manager: StructureManager

func _input(event: InputEvent) -> void:
	var move_vector = Input.get_vector("Left", "Right", "Up", "Down")
	move(move_vector)

func _ready() -> void:
	super()
	area_entered.connect(_on_area_entered)

func _on_area_entered(body):
	pass

func add_wood(amount: int):
	structure_manager.change_wood(amount)
