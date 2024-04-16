extends Area2D
class_name Projectile

@export var speed := 500
@export var damage := 1
@export var direction := Vector2.RIGHT : set = set_direction, get = get_direction

func _physics_process(delta: float) -> void:
	global_position += speed * delta * direction.normalized()

func get_direction():
	return direction
func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = new_direction.angle()	

func _destroy() -> void:
	queue_free()

func _ready() -> void:
	area_entered.connect(hit_area) 
	body_entered.connect(hit_body) 

func hit_body(_body) -> void:
	pass
	
func hit_area(_area) -> void:	
	pass
