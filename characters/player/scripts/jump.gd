extends PlayerState

func enter(_data: Dictionary) -> void:
	player.velocity.y = -player.jump_impulse

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	
	var x_direction = Input.get_axis("left", "right")
	player.velocity.x = player.speed * x_direction
	
	if(player.velocity.y > 0):
		s_finished.emit(FALL)
	player.move_and_slide()
