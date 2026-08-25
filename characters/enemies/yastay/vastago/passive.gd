@tool
extends EnemyState

@onready var vastago: Vastago = $"../.."
@onready var active_wait_time: Timer = $ActiveWaitTime
@onready var move_time: Timer = $MoveTime
@onready var stop_time: Timer = $StopTime
@onready var activate_detection: EnemyDetection = $"../../ShouldRotate/AreaDetections/ActivateDetection"

var player_ref = null
var is_stopped := true

func enter(_data: Dictionary) -> void:
	activate_detection.enable()
	vastago.sprite_animations.play("idle")
	move_time.start()
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(!vastago.is_on_floor()):
			enemy.enable_gravity(_delta)
		if(!is_stopped):
			enemy.move_forward(vastago.speed / 2.0)
		else:
			enemy.velocity.x = 0
		handle_turn_around()
		handle_transitions()
		enemy.move_and_slide()

func  handle_turn_around():
	if(vastago.is_on_floor() and not vastago.is_floor_colliding()):
		vastago.turn_around()
	if(vastago.is_wall_colliding()):			
		vastago.turn_around()

func wait() -> void:
	is_stopped = true
	var stop_duration = randf_range(vastago.min_stop_time_secs, vastago.max_stop_time_secs)
	stop_time.wait_time = stop_duration
	stop_time.start()
	vastago.sprite_animations.play("idle")

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	player_ref = null
	is_stopped = true

# Transitions via signals here
func _on_stop_time_timeout() -> void:
	is_stopped = false
	var turn_around_choice = randf() < 0.5
	if(turn_around_choice):
		vastago.turn_around()
	vastago.sprite_animations.play("run")
	var move_duration = randf_range(vastago.min_move_time_secs, vastago.max_move_time_secs)
	move_time.wait_time = move_duration
	move_time.start()

func _on_move_time_timeout() -> void:
	wait()

func _on_activate_detection_area_entered(_area: Area2D) -> void:
	if(state_machine.current_state.name == state_machine.PASSIVE):
		is_stopped = true
		player_ref = _area.owner
		activate_detection.disable()
		active_wait_time.start()
		print("SHOW EXCLAMATION")
		vastago.sprite_animations.play("idle")
		vastago.velocity.x = 0.0

func _on_active_wait_time_timeout() -> void:
	move_time.stop()
	stop_time.stop()
	vastago.turn_towards(player_ref.global_position)
	transition_to(state_machine.ACTIVE,{
		"player" : player_ref
	})
