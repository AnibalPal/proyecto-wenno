@tool
extends PlayerState

var attack_finished := false

func enter(_data: Dictionary) -> void:
	player.player_animations.play("attack")
	player.velocity.x = 0
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
	if(attack_finished):
		if(Input.is_action_pressed("right") or Input.is_action_pressed("left")):
			s_finished.emit(state_data.RUN)
		else:
			s_finished.emit(state_data.IDLE)

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	attack_finished = false

func _on_player_animations_animation_finished() -> void:
	if(player.player_animations.animation == "attack"):
		attack_finished = true
