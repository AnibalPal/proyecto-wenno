extends PlayerState

func enter(_data: Dictionary) -> void:
	return

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	player.enable_gravity(_delta)
	player.enable_x_movement()
	handle_transitions()
	player.move_and_slide()

func handle_transitions() -> void:
	if(!player.is_on_floor()):
		s_finished.emit(FALL)

	if(Input.is_action_just_pressed("jump")):
		s_finished.emit(JUMP)

	if(is_equal_approx(player.velocity.x, 0.0)):
		s_finished.emit(IDLE)
