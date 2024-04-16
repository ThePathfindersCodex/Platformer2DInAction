extends Projectile

func _init():
	pass

func _ready() -> void:
	top_level=true
	super()

func hit_body(body) -> void:
	print("ENEMYBULLET hit_body  ",body.get_name())
	if body.get_name()=="Player":
		if body.has_method("take_damage"):
			body.take_damage(damage)
	_destroy()

func hit_area(area) -> void:
	print("ENEMYBULLET hit_area  ",area.get_name())
	if area.get_name()=="Player":
		if area.has_method("take_damage"):
			area.take_damage(damage)
	_destroy()
