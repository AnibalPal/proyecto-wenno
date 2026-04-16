@tool
extends PlayerAttackState

func state_physics_process(_delta: float) -> void:
	if(active):
		# player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

# Functions to override
# Transitions when the attack animation finishes
func handle_attack_finished_transitions() -> void:
	pass

# Normal transitions	
func handle_attack_transitions() -> void:
	pass
