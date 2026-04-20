@tool
extends PlayerAttackState

func state_physics_process(_delta: float) -> void:
	if(active):
		# player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_attack_finished_transitions() -> void:
	if(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		transition_to(state_data.RUN)
	else:
		transition_to(state_data.IDLE)
	
func handle_attack_transitions() -> void:
	pass
