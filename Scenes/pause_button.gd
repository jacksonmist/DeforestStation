extends Node

@export var gm: GameManager

func _input(event: InputEvent) -> void:
	if not gm.has_started:
		return
	if event.is_action_pressed("Pause"):
		if gm.is_paused:
			gm.resume_game()
		else:
			gm.pause_game()
