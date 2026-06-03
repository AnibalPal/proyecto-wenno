@tool
extends PlayerState

# In this state, the player is controlled externally by the engine

@onready var player_hurtbox: PlayerHurtbox = $"../../ShouldRotate/Hurtbox"
@onready var player_trigger_collision: CollisionShape2D = $"../../ShouldRotate/PlayerTrigger/CollisionShape2D"
@onready var move_duration: Timer = $MoveDuration

var has_gravity := true
var trigger_end := false

enum CutsceneStates {
	NONE,
	MOVEX,
	MOVEY
}

var current_state := CutsceneStates.NONE

func enter(_data: Dictionary) -> void:
	player_trigger_collision.set_deferred("disabled", true)
	player_hurtbox.disable()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(has_gravity):
			player.enable_gravity(_delta)
		match current_state:
			CutsceneStates.NONE:
				pass
			CutsceneStates.MOVEX:
				if(player.is_on_floor() and abs(player.velocity.x) > 0):
					player.player_animations.play("run")
			CutsceneStates.MOVEY:
				if(player.is_on_floor()):
					end()
		player.move_and_slide()

# Functions that must be used externally
func move_action(end_cutscene:= false) -> void:
	move_duration.start()
	trigger_end = end_cutscene

func move_up(end_cutscene:= false) -> void:
	current_state = CutsceneStates.MOVEY
	move_action(end_cutscene)
	has_gravity = false
	player.velocity.y = -player.jump_impulse
	player.player_animations.play("jump")

func move_right(end_cutscene:= false) -> void:
	current_state = CutsceneStates.MOVEX
	move_action(end_cutscene)
	player.turn_right()
	player.velocity.x = player.speed
	
func fall(end_cutscene:= false) -> void:
	current_state = CutsceneStates.MOVEY
	move_action(end_cutscene)
	player.velocity.x = 0
	player.velocity.y = 0
	player.player_animations.play("fall")
	has_gravity = true

func move_left(end_cutscene:= false) -> void:
	current_state = CutsceneStates.MOVEX
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
	if(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		transition_to(state_data.RUN)
	else:
		transition_to(state_data.IDLE)

func _on_move_duration_timeout() -> void:
	player.velocity.x = 0
	if(trigger_end):
		end()
