extends PlayerTrigger
signal TriggerPistol(s, body)
	
func _on_body_entered(body):
	emit_signal("TriggerPistol", self, body)

func get_item(body):
	body.has_pistol=true
