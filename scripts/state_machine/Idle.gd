extends PlayerState

func enter(_msg := {}) -> void:
	print('ENTER IDLE ',player.velocity,_msg)
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	player.get_node("AnimatedSprite2D").play("default")
	player.get_node("AnimatedSprite2D").frame=0
	player.get_node("AnimatedSprite2D").stop()

	if !is_equal_approx(player.velocity.x, 0.0):
		player.velocity = player.velocity + Vector2.UP
		player.move_and_slide()
	else:
		if Input.is_action_just_pressed("jump"):
			state_machine.transition_to("Air", {do_jump = true})
		elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			state_machine.transition_to("Run")
