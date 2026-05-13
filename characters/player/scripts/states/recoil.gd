@tool
extends PlayerState

@export var player_hurtbox : PlayerHurtbox
@export var pushback_velocity := Vector2(-300,0)

@onready var duration: Timer = $Duration

var hit_end := false

func enter(_data: Dictionary) -> void:
	assert(player_hurtbox, "Hit state: No player hurtbox set!")
	GlobalVFXs.hitstop()
	player.disable_hitboxes()
	reset_state()
	duration.start()
	if(_data.has("interaction_data")):
		var is_area_right_of_player := player.global_position.direction_to(_data["interaction_data"]["area_position"]).x > 0
		if(is_area_right_of_player):
			player.turn_right()
			player.velocity = pushback_velocity
		else:
			player.turn_left()
			player.velocity = Vector2(-pushback_velocity.x, pushback_velocity.y)
	player_hurtbox.disable()
	player.player_animations.play("recoil")

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_transitions() -> void:
	if(hit_end):
		if(player.is_on_floor()):
			transition_to(state_data.IDLE)
		else:
			transition_to(state_data.FALL)

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	hit_end = false

func _on_duration_timeout() -> void:
	player_hurtbox.enable()
	hit_end = true
