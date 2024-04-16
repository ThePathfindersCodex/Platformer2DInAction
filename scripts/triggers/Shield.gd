extends PlayerTrigger
signal TriggerShield(s, body)
		
func _on_body_entered(body):
	emit_signal("TriggerShield", self, body)

func get_item(body):
	body.has_shield=true
