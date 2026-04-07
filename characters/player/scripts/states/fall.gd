@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	return

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		player.enable_x_movement()
		handle_transitions()	
		player.move_and_slide()

func handle_transitions() -> void:
	if(player.is_on_floor()):
		if(is_equal_approx(player.velocity.x, 0.0)):
			s_finished.emit(state_data.IDLE)
		else:
			s_finished.emit(state_data.RUN)
