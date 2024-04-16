extends Area2D
class_name EnemyBase

func _physics_process(_delta: float) -> void:
	pass
	
func _ready():
	get_node("EnemyStats").health_depleted.connect(dead)
	body_entered.connect(_on_area_entered)
	area_entered.connect(_on_area_entered)

func dead():
	self.visible=false
	self.get_node("CollisionShape2D").set_deferred("disabled",true)
	#queue_free()

func take_damage(damage):
	get_node("EnemyStats").take_damage(damage)

func _on_body_entered(body):
	print("ENEMYBASE _on_body_entered  ",body.get_name())
	if body.get_name()=="Player":
		body.take_damage(1)
	elif  body.get_name()=="Bullet":
		take_damage(1)

func _on_area_entered(area):
	print("ENEMYBASE _on_area_entered  ",area.get_name())
	if area.get_name()=="Player":
		area.take_damage(1)
	elif  area.get_name()=="Bullet":
		take_damage(1)
