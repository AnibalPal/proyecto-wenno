@tool
extends PlayerState

var enable_x_movement := true
var start_fall := false

func enter(_data: Dictionary) -> void:
	player.player_animations.play("air_attack")
	reset_state()

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

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

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	enable_x_movement = true
	start_fall = false

func _on_player_animations_animation_finished() -> void:
	if(player.player_animations.animation == "air_attack"):
		if(player.is_on_floor()):
			if(is_equal_approx(player.velocity.x, 0.0)):
				s_finished.emit(state_data.IDLE)
			else:
				s_finished.emit(state_data.RUN)
		else:
			if(player.velocity.y <= 0):
				s_finished.emit(state_data.JUMP, { "no_impulse": true })
			else:
				s_finished.emit(state_data.FALL)
				
				
