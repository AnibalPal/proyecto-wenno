@tool
extends PlayerState

@onready var coyote_time: Timer = $CoyoteTime

var jump_available := false

func enter(_data: Dictionary) -> void:
	reset_state()
	if(_data.has("activate_coyote")):
		jump_available = true
		coyote_time.start()

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		player.enable_x_movement()
		handle_transitions()	
		player.move_and_slide()

func handle_transitions() -> void:
	if(Input.is_action_just_pressed("jump") and jump_available):
		s_finished.emit(state_data.JUMP)
	
	if(player.is_on_floor()):
		if(is_equal_approx(player.velocity.x, 0.0)):
			s_finished.emit(state_data.IDLE)
		else:
			s_finished.emit(state_data.RUN)
		return

func reset_state():
	jump_available = false

func _on_coyote_time_timeout() -> void:
	jump_available = false
