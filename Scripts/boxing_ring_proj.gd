class_name BoxingRingProjectile extends Projectile

func enemy_hit(body):
	if body and body.has_method("knockback") and body.is_active:
		body.knockback(knockback, direction)
		queue_free()
