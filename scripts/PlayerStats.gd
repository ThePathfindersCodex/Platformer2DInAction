extends Node
class_name PlayerStats

signal health_changed(old_value, new_value)
signal health_depleted()
signal damage_taken()

var invulnerable := false
var input_locked := false

@export var max_health := 5.0  : set = set_max_health, get = get_max_health
var health := max_health

func _ready() -> void:
	health = max_health

func take_damage(damage) -> void:
	if invulnerable:
		return
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

func set_invulnerable_for_seconds(time: float, block_input:bool=false) -> void:
	invulnerable = true
	if block_input:
		input_locked=true
	var timer := get_tree().create_timer(time)
	await timer.timeout
	invulnerable = false
	if block_input:
		input_locked=false	
