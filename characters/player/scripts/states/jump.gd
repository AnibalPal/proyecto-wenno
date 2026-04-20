@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	player.player_animations.play("jump")
	if(_data.has("no_impulse")):
		if(_data["no_impulse"]):
			player.velocity.y = 0
	else:
		player.velocity.y = -player.jump_impulse

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
		player.velocity.y = 0.0
		transition_to(state_data.FALL)
		return
	
	if(Input.is_action_just_pressed("attack")):
		transition_to(state_data.AIRATTACK)
		return
	
	if(player.velocity.y > 0):
		transition_to(state_data.FALL)
		return
