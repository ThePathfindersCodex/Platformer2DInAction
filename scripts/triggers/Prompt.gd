extends PlayerTrigger
signal ToggleZoneActive(s,body)
signal ToggleZoneInactive(s,body)
signal ExecutedPrompt(s)

@export var ToggleZoneState = false

func _ready():
	super()
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	emit_signal("ToggleZoneActive", self, body)
	ToggleZoneState=true
	
func _on_body_exited(body):
	emit_signal("ToggleZoneInactive", self, body)
	ToggleZoneState=false

func ExecutePrompt():
	emit_signal("ExecutedPrompt", self)
