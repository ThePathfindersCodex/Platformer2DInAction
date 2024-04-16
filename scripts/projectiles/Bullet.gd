extends Projectile

func _init():
	pass

func _destroy() -> void:
	Globals.playerInst.active_bullet=false
	super()

func set_direction(new_direction: Vector2) -> void:
	$Sprite2D.scale *= 1
	super(new_direction)

func hit_area(area) -> void:
	print("BULLET hit_area  ",area.get_name())
	if area.get_name()=="Boss":
		if area.has_method("take_damage"):
			area.take_damage(damage)
	_destroy()

func hit_body(body) -> void:
	print("BULLET hit_body  ",body.get_name())
	if body.get_name()=="Boss":
		if body.has_method("take_damage"):
			body.take_damage(damage)
	_destroy()
