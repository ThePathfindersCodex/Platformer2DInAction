extends EnemyBase

var ebullet_scene = preload("res://scenes/EnemyBullet.tscn")
@onready var sound_flame = $SoundFlame

func _physics_process(_delta: float) -> void:
	if $BossZone.active:
		enemyAttacking()
		start_boss_music()
	else:
		stopAttacking()
		stop_boss_music()

func start_boss_music():
	if Globals.levelInst.get_node("AudioStreamPlayer").playing:
		Globals.levelInst.get_node("AudioStreamPlayer").stop()
		Globals.levelInst.get_node("AudioStreamPlayerBoss").play()
func stop_boss_music():
	if Globals.levelInst.get_node("AudioStreamPlayerBoss").playing:
		Globals.levelInst.get_node("AudioStreamPlayerBoss").stop()	
		Globals.levelInst.get_node("AudioStreamPlayer").play()

func _ready():
	super()
	$BreathWeapon/Timer.timeout.connect(attack)
	$Panel/Label.text=str($EnemyStats.health)

func _on_body_entered(body):
	print("BOSS _on_body_entered  ",body.get_name())
	if body.get_name()=="Player":
		body.take_damage(5)

func attack():
	var instance = ebullet_scene.instantiate()
	instance.position = $BreathWeapon.global_position
	
	var randAngle = Vector2(0,randf_range(-PI / 8, PI / 4))
	var randVector = Vector2.LEFT + randAngle
	instance.set_direction(randVector)
	add_child(instance)
	sound_flame.play()

func enemyAttacking():
	if $BreathWeapon/Timer.is_stopped():
		attack()
		$BreathWeapon/Timer.start()
		
func stopAttacking():
	if !($BreathWeapon/Timer.is_stopped()):
		$BreathWeapon/Timer.stop()
		
func take_damage(damage):
	super(damage)
	$Panel/Label.text=str($EnemyStats.health)
	
func dead():
	super()
	$BossZone.get_node("CollisionShape2D").set_deferred("disabled",true)
	self.get_node("CollisionShape2D").set_deferred("disabled",true)
	self.get_node("CollisionShape2D2").set_deferred("disabled",true)
	
	$Panel/Label.visible=false
	#queue_free()
