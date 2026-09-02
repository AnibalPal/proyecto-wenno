@tool
extends EnemyState

@onready var active_wait_time: Timer = $ActiveWaitTime
@onready var move_time: Timer = $MoveTime
@onready var stop_time: Timer = $StopTime
@onready var activate_detection: EnemyDetection = $"../../ShouldRotate/AreaDetections/ActivateDetection"

var player_ref = null
var is_stopped := true

func enter(_data: Dictionary) -> void:
	enemy.counter_hit_state = false
	enemy.disable_hitboxes()
	activate_detection.enable()
	enemy.sprite_animations.play("idle")
	move_time.start()
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(!enemy.is_on_floor()):
			enemy.enable_gravity(_delta)
		if(!is_stopped):
			enemy.move_forward(enemy.speed / 2.0)
		else:
			enemy.velocity.x = 0
		handle_turn_around()
		handle_transitions()
		enemy.move_and_slide()

func handle_turn_around():
	if(enemy.is_on_floor() and not enemy.is_floor_colliding()):
		enemy.turn_around()
	if(enemy.is_wall_colliding()):			
		enemy.turn_around()

func wait() -> void:
	is_stopped = true
	var stop_duration = randf_range(enemy.min_stop_time_secs, enemy.max_stop_time_secs)
	stop_time.wait_time = stop_duration
	stop_time.start()
	enemy.sprite_animations.play("idle")

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
		enemy.turn_around()
	enemy.sprite_animations.play("run")
	var move_duration = randf_range(enemy.min_move_time_secs, enemy.max_move_time_secs)
	move_time.wait_time = move_duration
	move_time.start()

func _on_move_time_timeout() -> void:
	wait()

func _on_activate_detection_area_entered(_area: Area2D) -> void:
	if(state_machine.current_state.name == state_machine.PASSIVE):
		is_stopped = true
		player_ref = _area.owner
		owner.player_ref = _area.owner
		activate_detection.disable()
		active_wait_time.start()
		print("SHOW EXCLAMATION")
		enemy.sprite_animations.play("idle")
		enemy.velocity.x = 0.0

func _on_active_wait_time_timeout() -> void:
	move_time.stop()
	stop_time.stop()
	enemy.turn_towards(player_ref.global_position)
	transition_to(state_machine.ACTIVE,{
		"player" : player_ref
	})
