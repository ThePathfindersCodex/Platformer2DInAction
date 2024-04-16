class_name Player
extends CharacterBody2D

@export var has_boots = false
@export var has_key = false
@export var has_pistol = false
@export var has_shield = false

@export var camZoomMin := 0.5
@export var camZoomMax := 2.0
@export var camZoomSpeed := 0.1

# Horizontal speed in pixels per second.
@export var speed := 400.0 
# Vertical acceleration in pixel per second squared.
@export var gravity := 3500.0
# Vertical speed applied when jumping.
@export var jump_impulse := 1200.0
# Horizontal speed increase with boots on
@export var boost_speed := 400.0
# LERP friction for slowing down
@export var friction = 0.99
# LERP accel for speeding up
@export var acceleration = 0.1

var active_bullet := false
var last_facing := 1

var bullet_scene = preload("res://scenes/Bullet.tscn")

@onready var sound_jump = $SoundJump
@onready var sound_shoot = $SoundShoot
@onready var sound_hit = $SoundHit
@onready var coin_hit = $SoundCoin
@onready var gameover_sfx = $SoundGameOver

@onready var fsm := $StateMachine

var knockback := Vector2.ZERO
var staggerTween

func _process(_delta: float) -> void:
	pass

func _ready():
	get_node("PlayerStats").health_depleted.connect(dead)	
	get_node("PlayerStats").health_changed.connect(health_changed)	

func check_facing(new_facing):
	var dir = sign(new_facing.x)
	if(dir != 0 && dir != last_facing):
		last_facing=dir
		scale.x=-1

func calculate_input_direction() -> Vector2:
	if !$PlayerStats.input_locked:
		return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"), Input.get_action_strength("down") - Input.get_action_strength("up")).normalized()
	return Vector2.ZERO

func _on_StateMachine_transitioned(current_state):
	Globals.debugInst.get_node("DebugPanel/PState").text = String(current_state)
	
func _physics_process(_delta: float) -> void:
	handle_camera()
	handle_guns()
	handle_use_actions()

func handle_camera():
	if Input.is_action_just_released("zoomin"):
		if Globals.camInst.zoom.x >= camZoomMin:
			Globals.camInst.zoom.x  -= camZoomSpeed
			Globals.camInst.zoom.y  -= camZoomSpeed
	elif Input.is_action_just_released("zoomout"):
		if Globals.camInst.zoom.x <= camZoomMax:
			Globals.camInst.zoom.x  += camZoomSpeed
			Globals.camInst.zoom.y  += camZoomSpeed

func handle_guns():
	if has_pistol && !active_bullet && Input.is_action_just_pressed("shoot") && !$PlayerStats.input_locked:
		active_bullet=true
		start_bullet()

func start_bullet():
	var instance = bullet_scene.instantiate()
	instance.set_direction(Vector2(last_facing,0))
	instance.translate(Vector2(position.x+(16*last_facing),position.y+16))
	get_parent().add_child(instance)
	sound_shoot.play()


var current_toggle=null
func set_current_toggle(s):
	current_toggle=s
func clear_current_toggle():
	current_toggle=null
func handle_use_actions():
	if Input.is_action_just_released("use"):
		if current_toggle != null:
			if current_toggle.get_name()=="Toggle":
				current_toggle.FlipToggle()
			elif current_toggle.get_name()=="Prompt":
				current_toggle.ExecutePrompt()
			elif current_toggle.get_name()=="Portal" || current_toggle.get_name()=="Portal2":
				# TODO: rewrite to use Groups instead of get_name()
				current_toggle.Teleport()
				
func dead():
	gameover_sfx.play()
	
	set_process_input(false)
	set_physics_process(false)
	Globals.hudInst.get_node("UI/Panels/GameOverPanel").visible=true
	Globals.GamePaused = true
	get_tree().paused = true
	
func health_changed(_old_value, _new_value):
	Globals.hudInst.get_node("HealthPanel/health").text = str($PlayerStats.health)

func take_damage(damage):
	$PlayerStats.take_damage(damage)
	$StateMachine.transition_to("Stagger")
	
	$AnimatedSprite2D/SpriteDmg.visible=true
	$AnimatedSprite2D/SpriteDmg/Timer.start()
	sound_hit.play()

func _on_Timer_timeout():
	$AnimatedSprite2D/SpriteDmg.visible=false
	pass
	
