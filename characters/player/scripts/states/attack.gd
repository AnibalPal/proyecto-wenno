@tool
extends PlayerAttackState

@onready var input_buffer: Timer = $InputBuffer

var buffered_state := ""

func state_physics_process(_delta: float) -> void:
	if(active):
		# player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_attack_transitions() -> void:
	if(Input.is_action_just_pressed("attack")):
		input_buffer.start()
		buffered_state = state_data.ATTACK
	
	if(Input.is_action_just_pressed("jump")):
		input_buffer.start()
		buffered_state = state_data.JUMP

func handle_attack_finished_transitions() -> void:
	if(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		transition_to(state_data.RUN)
	else:
		transition_to(state_data.IDLE)
	
	if(!input_buffer.is_stopped()):
		input_buffer.stop()
		if(Input.is_action_pressed("right")):
			player.turn_right()
		if(Input.is_action_pressed("left")):
			player.turn_left()
		transition_to(buffered_state)

func reset_state()  -> void:
	attack_finished = false
	input_buffer.stop()
	buffered_state = ""
