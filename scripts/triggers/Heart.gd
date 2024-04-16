extends PlayerTrigger
signal TriggerHeart(s, body)
		
func _on_body_entered(body):
	if body.get_node("PlayerStats").health < body.get_node("PlayerStats").max_health:
		emit_signal("TriggerHeart", self, body)

