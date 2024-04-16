extends PlayerTrigger
signal BossActive()
signal BossInactive()

var active=false

func _ready():
	super()
	body_exited.connect(self._on_body_exited)
	
func _on_body_entered(_body):
	print("boss active")
	emit_signal("BossActive")
	active=true
	
func _on_body_exited(_body):
	print("boss inactive")
	emit_signal("BossInactive")
	active=false
