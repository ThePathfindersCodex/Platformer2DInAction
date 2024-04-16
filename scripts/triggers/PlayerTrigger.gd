extends Area2D
class_name PlayerTrigger

func _ready(): 
	body_entered.connect(self._on_body_entered)

func disable():
	visible=false
	get_node("CollisionShape2D").set_deferred("disabled",true)
	
func get_item(_body):
	pass
