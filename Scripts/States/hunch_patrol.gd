class_name HunchoPatrol extends State

var timer: Timer
var target_pos: Vector2

func enter_state() ->  void:
	if not timer:
		timer = Timer.new()
		timer.autostart = false
		timer.wait_time = 10
		timer.one_shot = true
		timer.timeout.connect(_on_timeout)
		parent.add_child(timer)
	_on_timeout()

func update(_delta: float) -> void:
	if not parent.imm_targets.is_empty():
		sm.change_state(sm.states[HunchoAttack])
		return
	if parent.global_position.distance_to(target_pos) <= 1 and timer.is_stopped():
		parent.move(Vector2.ZERO)
		timer.start()

func _on_timeout():
	var angle = randf_range(0, 2 * PI)
	var vector = Vector2(cos(angle), sin(angle))
	var magnitude: float
	if house:
		magnitude = house.radius * 16
	else:
		magnitude = 5 * 16
	target_pos = vector * magnitude
	var mov_dir := (target_pos - parent.global_position).normalized()
	parent.move(mov_dir)

func exit_state() -> void:
	if not timer.is_stopped():
		timer.stop()
		parent.move(Vector2.ZERO)
