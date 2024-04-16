extends PlayerTrigger
signal TriggerBoots(s, body)
		
func _on_body_entered(body):
	emit_signal("TriggerBoots", self, body)

func get_item(body):
	body.has_boots=true
