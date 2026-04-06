extends PlayerState

func enter(_data: Dictionary) -> void:
	return

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	var x_direction = Input.get_axis("left", "right")
	player.velocity.x = player.speed * x_direction

	if(Input.is_action_just_pressed("jump")):
		s_finished.emit(JUMP)

	if(is_equal_approx(x_direction, 0.0)):
		s_finished.emit(IDLE)
	player.move_and_slide()
