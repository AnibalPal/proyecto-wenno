@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	player.player_animations.play("idle")
	player.velocity = Vector2.ZERO

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		handle_transitions()
		player.move_and_slide()

func handle_transitions() -> void:
	if(!player.is_on_floor()):
		transition_to(state_data.FALL, {"activate_coyote": true})
		return
	
	if(player.floor_detection.is_colliding()):
		# Go down logic normally
		if(Input.is_action_just_pressed("jump") and Input.is_action_pressed("down")):
			player.position.y += 1
			transition_to(state_data.FALL)
			return
	
	if(Input.is_action_just_pressed("jump")):
		transition_to(state_data.JUMP)
		return
	
	if(Input.is_action_just_pressed("attack")):
		transition_to(state_data.ATTACK)
		return
	
	if(Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return
	
	if(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		transition_to(state_data.RUN)
		return
