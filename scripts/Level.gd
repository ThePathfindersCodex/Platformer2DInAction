extends TileMap

@onready var win_sfx = $AudioStreamPlayerWinMusic

var triggers_map = {
"Star": "TriggerWin",
"Boots": "TriggerBoots",
"Key": "TriggerKey",
"Lock": "TriggerLock",
"Pistol": "TriggerPistol",
"Shield": "TriggerShield",
"Heart1": "TriggerHeart",
"Heart2": "TriggerHeart",
"Heart3": "TriggerHeart",
"Heart4": "TriggerHeart",
"Heart5": "TriggerHeart",
"Heart6": "TriggerHeart",
"Heart7": "TriggerHeart",
"Toggle": ["ToggleZoneActive","ToggleZoneInactive","Toggled"],
"Prompt":  ["ToggleZoneActive","ToggleZoneInactive","ExecutedPrompt"],
"Portal":  ["ToggleZoneActive","ToggleZoneInactive","Teleported"],
"Portal2":  ["ToggleZoneActive","ToggleZoneInactive","Teleported"],
}

@onready var messagePanel = Globals.hudInst.get_node("UI/Panels/MessagePanel")
func _on_MessagePanel_timeout():
	Globals.hudInst.get_node("UI/Panels/MessagePanel").visible=false
	
func _ready():
	messagePanel.get_node("Timer").timeout.connect(_on_MessagePanel_timeout)
	
func _on_Area2D_body_entered(body):
	# hazard damage
	print("LEVEL ("+get_name()+") _on_Area2D_body_entered  ",body.get_name())
	body.take_damage(1)
	
func init_player_triggers():
	for key in triggers_map:
		var value = triggers_map[key]
		if value is Array:
			for k in value:
				if Globals.levelInst.get_node_or_null("PlayerTriggers/"+key):
					Globals.levelInst.get_node("PlayerTriggers/"+key)[k].connect(self[k])
		else:
			if Globals.levelInst.get_node_or_null("PlayerTriggers/"+key):
				Globals.levelInst.get_node("PlayerTriggers/"+key)[value].connect(self[value])
		
func start_level():
	Globals.levelInst.get_node("AudioStreamPlayer").play()
	TutorialStart()

func TutorialStart():
	SetMessagePanel( "Move LEFT or RIGHT.\n\nPress X to jump.", 3)
	
func SetMessagePanel(label, time):
	messagePanel.get_node("Label").text = label
	messagePanel.get_node("Timer").wait_time = time
	messagePanel.visible=true
	messagePanel.get_node("Timer").start()	

func HandleItemTrigger(s,body,trigger):
	DisableTrigger(s)
	body.get_node("AnimatedSprite2D/Sprite"+trigger).visible=true
	s.get_item(body)

func HandleHealTrigger(s,body,_trigger):
	DisableTrigger(s)
	s.get_item(body)

func DisableTrigger(s):
	s.disable()
	
func TriggerKey(s, body):
	HandleItemTrigger(s,body,"Key")
	Globals.playerInst.coin_hit.play()
	SetMessagePanel("You picked up a mysterious key!", 4)

func TriggerBoots(s,body):
	HandleItemTrigger(s,body,"Boots")
	Globals.playerInst.coin_hit.play()
	SetMessagePanel("You picked up Winged Boots!\n\nHold SQUARE to sprint and jump farther.", 5)

func TriggerPistol(s, body):
	HandleItemTrigger(s,body,"Pistol")
	
	Globals.playerInst.coin_hit.play()
	SetMessagePanel("You picked up a Pistol.  Pew. Pew. Pew.\n\nPull the R2 Trigger to fire.", 3)
	
func TriggerShield(s,body):
	HandleItemTrigger(s,body,"Shield")
	
	Globals.playerInst.coin_hit.play()
	Globals.playerInst.get_node("PlayerStats").set_max_health(10)
	Globals.playerInst.get_node("PlayerStats").heal(Globals.playerInst.get_node("PlayerStats").max_health)
	SetMessagePanel("You picked up a shiny Shield.\n\nMaybe you won't die... maybe...", 3)	

func TriggerHeart(s,body):
	HandleHealTrigger(s,body,"Heart")
	Globals.playerInst.coin_hit.play()
	Globals.playerInst.get_node("PlayerStats").heal(1)

func TriggerLock(s,body):
	var msg
	if s.locked:
		if body.has_key:
			Globals.playerInst.coin_hit.play()
			msg = "You insert the key into the\nlock and you hear a loud thud."
			s.locked=false
			for key in s.doortiles:
				Globals.levelInst.set_cell( 0, key, -1 )
			DisableTrigger(s)
#			body.get_node("AnimatedSprite2D/SpriteKey").visible=false
			s.get_node("SoundUnlock").play()
		else:
			msg = "This lock controls a\nhidden path... just\nneed to find a key."
			
		SetMessagePanel(msg, 4)	

func ToggleZoneActive(s,body):
	s.get_node("Panel").visible=true
	body.set_current_toggle(s)

func ToggleZoneInactive(s,body):
	s.get_node("Panel").visible=false
	body.clear_current_toggle()

func Toggled(s,newval):
	if !newval:
		s.get_node("Sprite2D").rotation_degrees = 0
		$Lights/PointLightSwitch.visible=false
	else:
		s.get_node("Sprite2D").rotation_degrees = 180
		$Lights/PointLightSwitch.visible=true

func ExecutedPrompt(s):
	SetMessagePanel("DO NOT TOUCH\nTHE RED BLOCKS!!\n\nCollect Hearts if\nyou are hurt.", 4)
	s.visible=false
	s.get_node("CollisionShape2D").set_deferred("disabled",true)

func Teleported(s):
	Globals.playerInst.translate(s.get_portal_dest())
	Globals.playerInst.move_and_slide()
	
func TriggerWin():
	win_sfx.play()
	
	Globals.GamePaused = true
	get_tree().paused = true
	
	Globals.hudInst.get_node("UI/Panels/WinPanel/LabelTime").text = str(snapped(Globals.gameInst.activetime,0.001))
	Globals.hudInst.get_node("UI/Panels/WinPanel").visible=true
	



