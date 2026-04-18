@tool
extends PlayerState
class_name PlayerAttackState

@export var hitbox : HitBox
@export var animation_name: String
@export var active_start_frame := 2
@export var active_end_frame := 3

var attack_finished := false

# This class handles the following:
# - Have variables that hold move frame data and animation names
# - Connect animation signals to disable / enable hitboxes automatically
	
func player_state_ready():
	assert(hitbox, name + ": Falta hitbox")
	assert(animation_name, name + ": Falta nombre de animación")
	player.player_animations.frame_changed.connect(on_animation_frame_changed)
	player.player_animations.animation_finished.connect(on_animation_finished)
	
func enter(_data: Dictionary) -> void:
	player.player_animations.play(animation_name)
	player.velocity.x = 0
	reset_state()

func handle_transitions() -> void:
	if(attack_finished):
		handle_attack_finished_transitions()
	else:
		handle_attack_transitions()

func reset_state()  -> void:
	attack_finished = false

func on_animation_finished() -> void:
	if(player.player_animations.animation == animation_name):
		attack_finished = true

func on_animation_frame_changed() -> void:
	if(player.player_animations.animation == animation_name):
		if(player.player_animations.frame == active_start_frame):
			hitbox.enable()
			return
		if(player.player_animations.frame >= active_end_frame):
			print("DISABLE")
			hitbox.disable()
			return

# Override in children
func handle_attack_finished_transitions() -> void:
	pass

func handle_attack_transitions() -> void:
	pass

# Wrapper for the state finished transition in order to disable hitboxes before changing state
func attack_state_finished(new_state: String, data := {}) -> void:
	hitbox.disable()
	s_finished.emit(new_state, data)
