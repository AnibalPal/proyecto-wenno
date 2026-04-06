extends PlayerState

func enter(_data: Dictionary) -> void:
	player.velocity = Vector2.ZERO

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	player.enable_gravity(_delta)
	handle_transitions()
	player.move_and_slide()

func handle_transitions() -> void:
	if(!player.is_on_floor()):
		s_finished.emit(FALL)
	
	if(Input.is_action_just_pressed("jump")):
		s_finished.emit(JUMP)
	
	if(Input.is_action_pressed("right") and Input.is_action_pressed("left")):
		return
	
	if(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		s_finished.emit(RUN)
