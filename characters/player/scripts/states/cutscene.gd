@tool
extends PlayerState

# In this state, the player is controlled externally by the engine

@onready var player_hurtbox: PlayerHurtbox = $"../../ShouldRotate/Hurtbox"
@onready var player_trigger_collision: CollisionShape2D = $"../../ShouldRotate/PlayerTrigger/CollisionShape2D"
@onready var move_duration: Timer = $MoveDuration

var has_gravity := true
var trigger_end := false

func enter(_data: Dictionary) -> void:
	player_trigger_collision.set_deferred("disabled", true)
	player_hurtbox.disable()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(has_gravity):
			player.enable_gravity(_delta)
		if(player.is_on_floor() and abs(player.velocity.x) > 0):
			player.player_animations.play("run")
		player.move_and_slide()

# Functions that must be used externally
func move_action(end_cutscene:= false) -> void:
	move_duration.start()
	trigger_end = end_cutscene

func move_up(end_cutscene:= false) -> void:
	move_action(end_cutscene)
	has_gravity = false
	player.velocity.y = -player.jump_impulse
	player.player_animations.play("jump")

func fall(end_cutscene:= false) -> void:
	move_action(end_cutscene)
	player.velocity.x = 0
	player.player_animations.play("fall")
	has_gravity = true

func move_right(end_cutscene:= false) -> void:
	move_action(end_cutscene)
	player.turn_right()
	player.velocity.x = player.speed

func move_left(end_cutscene:= false) -> void:
	move_action(end_cutscene)
	player.turn_left()
	player.velocity.x = -player.speed

func play_animation(anim_name: String) -> void:
	player.player_animations.play(anim_name)

func end() -> void:
	has_gravity = true
	trigger_end = false
	player_trigger_collision.set_deferred("disabled", false)
	player_hurtbox.enable()
	transition_to(state_data.IDLE)

func _on_move_duration_timeout() -> void:
	player.velocity.x = 0
	if(trigger_end):
		end()
