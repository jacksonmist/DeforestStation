class_name DifficultyManager extends Node

var time: float
var level: int
var x_per_level: float = 25.0
var difficulty: float

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta

func calculate_difficulty():
	var raw_difficulty = time + (level * x_per_level)

func update_level(value: int):
	level = value
