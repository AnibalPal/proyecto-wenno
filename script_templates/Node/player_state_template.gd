@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	reset_state()

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		# player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pass
