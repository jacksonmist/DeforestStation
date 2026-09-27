class_name DifficultyManager extends Node

var time: float
var level: int
var x_per_level: float = 60.0
var difficulty_mod: float = 0
var difficulty: float

@export var L: float = 50
@export var k: = 0.01
@export var x_0: float = 600.0
@export var difficulty_floor = 1.0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	difficulty = lgc(time + difficulty_mod)
	
func calculate_difficulty_mod():
	difficulty_mod = (level - 1) * x_per_level

func update_level(value: int):
	level = value
	calculate_difficulty_mod()

func lgc(x: float) -> float:
	var raw = L / (1 + exp(-k * (x - x_0)))
	return difficulty_floor + raw * (1.0 - difficulty_floor / L)
