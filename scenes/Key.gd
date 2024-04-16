extends PlayerTrigger
signal TriggerKey(s, body)
		
func _on_body_entered(body):
	emit_signal("TriggerKey", self, body)

func get_item(body):
	body.has_key=true
