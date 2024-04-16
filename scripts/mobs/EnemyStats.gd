extends Node
class_name EnemyStats

signal health_changed(old_value, new_value)
signal health_depleted()
signal damage_taken()

@export var max_health := 1.0 : set = set_max_health, get = get_max_health
var health := max_health

func _ready() -> void:
	health = max_health

func take_damage(damage) -> void:
	var old_health = health
	health -= damage
	emit_signal("damage_taken")
	health = max(0, health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")

func heal(amount: float) -> void:
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health)

func get_max_health():
	return max_health
func set_max_health(value: float) -> void:
	if value == null:
		return
	max_health = max(1, value)
