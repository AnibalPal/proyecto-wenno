@tool
extends PlayerAttackState

var enable_x_movement := true
var start_fall := false

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		if(enable_x_movement):
			player.enable_x_movement()
		handle_transitions()
		
		# Fall when jump not hold (should make another state but im justn fuckin lazy)
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
		if(is_equal_approx(player.velocity.x, 0.0)):
			transition_to(state_data.IDLE)
		else:
			transition_to(state_data.RUN)
	else:
		if(player.velocity.y <= 0):
			transition_to(state_data.JUMP, { "no_impulse": true })
		else:
			transition_to(state_data.FALL)

func handle_attack_transitions() -> void:
	pass

func reset_state()  -> void:
	attack_finished = false
	enable_x_movement = true
	start_fall = false
