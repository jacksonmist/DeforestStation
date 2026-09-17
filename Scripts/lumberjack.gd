class_name Lumberjack extends Entity

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is Wood:
		body.collect(self)
		return
	if not dis_targets.has(body):
		dis_targets.append(body)

func _on_body_exited(body):
	if dis_targets.has(body):
		dis_targets.erase(body)
