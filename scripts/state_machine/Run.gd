extends PlayerState

func enter(_msg := {}) -> void:
	print('ENTER RUN ',player.velocity,_msg)

func physics_update(delta: float) -> void:
	
	var input_direction = player.calculate_input_direction()
	player.check_facing(input_direction)
		
	if not player.is_on_floor():
		player.get_node("AnimatedSprite2D").stop()
		state_machine.transition_to("Air")
		return

	var input_direction_x: float = input_direction.x
	
	player.get_node("AnimatedSprite2D").play("move")
		
	var spd = player.speed
	if player.has_boots && Input.is_action_pressed("boost"):
		spd += player.boost_speed

	player.velocity.x = spd * input_direction_x
	player.velocity.y += player.gravity * delta
	
	player.velocity = player.velocity + Vector2.UP
	player.velocity += player.knockback
	player.move_and_slide()

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
