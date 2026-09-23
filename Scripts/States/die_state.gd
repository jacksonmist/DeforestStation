class_name DieState extends State

var vec_to_barracks: Vector2
var time: float
var speed: float = 30
var travel_time: float
var jump_height: float = 20
var rotation_speed: float = 10

func enter_state() ->  void:
	#print("Dead")
	time = 0
	vec_to_barracks = (barracks.position - parent.global_position).normalized()
	var distance = parent.global_position.distance_to(barracks.position)
	travel_time = distance / speed
	parent.drop_wood()
	parent.move(vec_to_barracks * speed)
	parent.is_dead = true

func update(_delta: float) -> void:
	time += _delta
	var t: float = clamp(time / travel_time, 0.0, 1.0)
	parent.sprite.position.y = -sin(t * PI) * jump_height
	parent.sprite.rotation += (rotation_speed * _delta)
	var move_direction = (barracks.position - parent.global_position).normalized()
	parent.position += (move_direction * speed * _delta)
	var distance = parent.global_position.distance_to(barracks.position)
	if distance <= 8:
		sm.change_state(sm.states[HealState])
		return

func exit_state() -> void:
	parent.can_pick_wood = true
	parent.is_dead = false
	parent.sprite.rotation = 0
