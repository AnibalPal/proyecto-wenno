@tool
extends PlayerState

@export var player_hurtbox : PlayerHurtbox
@export var pushback_velocity := Vector2(-200,-100)

@onready var pushback_duration: Timer = $PushbackDuration
@onready var invincible_duration: Timer = $InvincibleDuration
@onready var damaged_invul_effect: AnimationPlayer = $DamagedInvulEffect

var pushback_end := false

func enter(_data: Dictionary) -> void:
	assert(player_hurtbox, "Hit state: No player hurtbox set!")
	GlobalVFXs.hitstop()
	player.disable_hitboxes()
	reset_state()
	pushback_duration.start()
	if(_data.has("interaction_data")):
		var is_area_right_of_player := player.global_position.direction_to(_data["interaction_data"]["area_position"]).x > 0
		if(is_area_right_of_player):
			player.turn_right()
			player.velocity = pushback_velocity
		else:
			player.turn_left()
			player.velocity = Vector2(-pushback_velocity.x, pushback_velocity.y)
	player_hurtbox.disable()
	player.player_animations.play("hit")

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.enable_gravity(_delta)
		# player.enable_x_movement()
		handle_transitions()
		player.move_and_slide()

func handle_transitions() -> void:
	if(pushback_end):
		if(player.is_on_floor()):
			transition_to(state_data.IDLE)
		else:
			transition_to(state_data.FALL)

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pushback_end = false

func start_invincible() -> void:
	pushback_end = true
	damaged_invul_effect.play("damaged_invulnerable") 
	invincible_duration.start()

func end_invincible() -> void:
	damaged_invul_effect.stop()
	player_hurtbox.enable()

func _on_pushback_duration_timeout() -> void:
	start_invincible()

func _on_invincible_duration_timeout() -> void:
	end_invincible()
