extends PlayerTrigger
signal TriggerLock(s,body)

@export var locked = true

@export var doortiles = [
	Vector2(30,16)
]

func _on_body_entered(body):
	emit_signal("TriggerLock",self,body)
