extends PlayerState

func enter(_msg := {}) -> void:
	print('ENTER AIR ',player.velocity,_msg)
	if _msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		player.sound_jump.play()

func physics_update(delta: float) -> void:
	var input_direction = player.calculate_input_direction()
	player.check_facing(input_direction)
	
	var input_direction_x: float = input_direction.x
	
	player.get_node("AnimatedSprite2D").stop()
	
	var spd = player.speed
	if player.has_boots && Input.is_action_pressed("boost"):
		spd += player.boost_speed	

	player.velocity.x = spd * input_direction_x
	player.velocity.y += player.gravity * delta

	player.velocity = player.velocity + Vector2.UP
	player.velocity += player.knockback	
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
