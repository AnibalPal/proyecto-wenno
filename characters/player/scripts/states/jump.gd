@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	player.player_animations.play("jump")
	player.velocity.y = -player.jump_impulse

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
	if(!Input.is_action_pressed("jump")):
		s_finished.emit(state_data.FALL)
		return
	
	if(player.velocity.y > 0):
		s_finished.emit(state_data.FALL)
		return
