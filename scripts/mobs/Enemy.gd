extends EnemyBase

var last_facing := 1

func _physics_process(_delta: float) -> void:
	position.x += last_facing
	pass
	
func _on_area_entered(area):
	print("ENEMY _on_area_entered  ",area.get_name())
	super(area)
	if  area.get_name()=="Level1":  # TODO: use Type instead of Name?
		last_facing *= -1
		$Sprite2D.flip_h = !$Sprite2D.flip_h
