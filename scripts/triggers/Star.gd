extends PlayerTrigger
signal TriggerWin()

func _on_body_entered(_body):
	emit_signal("TriggerWin")
	
