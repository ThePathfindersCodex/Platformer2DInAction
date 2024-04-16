extends Node

var alltime=0	
var activetime=0	
var SceneLevel=preload("res://scenes/Level1.tscn")

func _ready():
	# game globals
	Globals.gameInst = self 
	Globals.pauseInst = $Level/PauseLayer
	Globals.hudInst = $Level/HUDLayer
	Globals.debugInst = $Level/HUDLayer/Debug
	Globals.camInst = $Player/Camera2D
	Globals.playerInst = $Player
	
	# remove the player temporarily
	remove_child(Globals.playerInst)
	
	# create new level scene instance and place it into the runtime level layer
	Globals.levelInst = SceneLevel.instantiate()
	$Level/LevelLayer.add_child(Globals.levelInst)
	
	# re-add the player, but place them into the runtime level layer at the SPAWN POINT
	Globals.playerInst.translate(Globals.levelInst.get_node("PlayerSpawn").position)
	$Level/LevelLayer.add_child(Globals.playerInst)
	
	# startup level
	Globals.levelInst.init_player_triggers()
	Globals.levelInst.start_level()


func _process(delta: float) -> void:
	handle_pause()
	
	# add time to the totals
	alltime+=delta
	if !Globals.GamePaused:
		activetime+=delta
	
	# debug print both time variables
	Globals.debugInst.get_node("DebugPanel/DebugText").text = str(alltime,"\n",activetime)


func handle_pause():
	if Globals.hudInst.get_node("UI/Panels/WinPanel").visible!=true && Globals.hudInst.get_node("UI/Panels/GameOverPanel").visible!=true:
		if Input.is_action_just_pressed("pause"):	
			if Globals.GamePaused:
				Globals.GamePaused = false
				Globals.pauseInst.get_node("PausePanel").visible=false
				get_tree().paused = false
			else:
				Globals.GamePaused = true
				Globals.pauseInst.get_node("PausePanel").visible=true
				get_tree().paused = true
