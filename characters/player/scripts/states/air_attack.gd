@tool
extends PlayerAttackState

@onready var input_buffer: Timer = $InputBuffer

var enable_x_movement := true
var start_fall := false
var buffered_state := ""

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		if(enable_x_movement):
			player.enable_x_movement()
		handle_transitions()
		
		# Fall when jump not hold (should make another state but im just fuckin lazy)
		if(!Input.is_action_pressed("jump") and not start_fall):
			if(player.velocity.y <= 0):
				player.velocity.y = 0
			start_fall = true
		
		# Disable movement when player is attacking on the floor so that players dont jump attack to avoid
		# attacking on the floor, kinda like the castlevania (aria of sorrow onwards) jump attack
		if(player.is_on_floor()):
			player.velocity.x = 0
			enable_x_movement = false
		
		player.move_and_slide()

func handle_attack_finished_transitions() -> void:
	if(player.is_on_floor()):
		if(buffered_state and !input_buffer.is_stopped()):
			if(Input.is_action_pressed("right")):
				player.turn_right()
			if(Input.is_action_pressed("left")):
				player.turn_left()
			transition_to(buffered_state)
			return		
		if(is_equal_approx(player.velocity.x, 0.0)):
			transition_to(state_data.IDLE)
		else:
			transition_to(state_data.RUN)
	else:
		if(buffered_state == state_data.ATTACK and !input_buffer.is_stopped()):
			transition_to(state_data.AIRATTACK)
			return
		if(player.velocity.y <= 0):
			transition_to(state_data.JUMP, { "no_impulse": true })
		else:
			transition_to(state_data.FALL)

func handle_attack_transitions() -> void:
	if(Input.is_action_just_pressed("attack")):
		input_buffer.start()
		buffered_state = state_data.ATTACK
	
	if(Input.is_action_just_pressed("jump")):
		input_buffer.start()
		buffered_state = state_data.JUMP

func reset_state()  -> void:
	attack_finished = false
	enable_x_movement = true
	start_fall = false
	input_buffer.stop()
	buffered_state = ""
