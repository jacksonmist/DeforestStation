class_name GameManager extends Node2D

@export var player_camera: Camera2D
var is_paused: bool = false
var has_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UiManager.set_game_manager(self)
	get_tree().paused = true
	is_paused = true

func start_game():
	get_tree().paused = false
	is_paused = false
	has_started = true
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(player_camera, "zoom", Vector2(1.0, 1.0), 3)

func pause_game():
	is_paused = true
	get_tree().paused = true
	UiManager.set_pause_menu(true)

func resume_game():
	is_paused = false
	get_tree().paused = false
	UiManager.set_pause_menu(false)

func restart_game():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
