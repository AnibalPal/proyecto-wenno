@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	player.player_animations.play("run")

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_transitions() -> void:
	if(!player.is_on_floor()):
		s_finished.emit(state_data.FALL, {"activate_coyote": true})
		return

	if(player.floor_detection.is_colliding()):
		# Go down logic normally
		if(Input.is_action_just_pressed("jump") and Input.is_action_pressed("down")):
			player.position.y += 1
			s_finished.emit(state_data.FALL)
			return

	if(Input.is_action_just_pressed("jump")):
		s_finished.emit(state_data.JUMP)
		return
		
	if(Input.is_action_just_pressed("attack")):
		s_finished.emit(state_data.ATTACK)
		return
	
	if(is_equal_approx(player.velocity.x, 0.0)):
		s_finished.emit(state_data.IDLE)
		return
