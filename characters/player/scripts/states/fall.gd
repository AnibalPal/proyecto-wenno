@tool
extends PlayerState

@onready var coyote_time: Timer = $CoyoteTime
@onready var input_buffer: Timer = $InputBuffer

var coyote_jump_available := false
var should_trigger_jump := false

func enter(_data: Dictionary) -> void:
	reset_state()
	player.player_animations.play("fall")
	if(_data.has("activate_coyote")):
		coyote_jump_available = true
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
	if(Input.is_action_just_pressed("jump") and coyote_jump_available):
		s_finished.emit(state_data.JUMP)
		return
	
	if(Input.is_action_just_pressed("jump")):
		should_trigger_jump = true
		input_buffer.start()
		return
	
	if(Input.is_action_just_pressed("attack")):
		s_finished.emit(state_data.AIRATTACK)
		return
		
	if(player.is_on_floor()):
		# Jump input buffer transitions
		if(should_trigger_jump):
			if(player.floor_detection.is_colliding() and Input.is_action_pressed("down")):
				player.position.y += 1
				s_finished.emit(state_data.FALL)
			else:
				s_finished.emit(state_data.JUMP)
			return
			
		# Normal fall transitions
		if(is_equal_approx(player.velocity.x, 0.0)):
			s_finished.emit(state_data.IDLE)
		else:
			s_finished.emit(state_data.RUN)
		return

func reset_state() -> void:
	coyote_jump_available = false
	should_trigger_jump = false

func _on_coyote_time_timeout() -> void:
	coyote_jump_available = false

func _on_input_buffer_timeout() -> void:
	should_trigger_jump = false
