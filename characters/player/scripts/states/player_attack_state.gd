@tool
extends PlayerState
class_name PlayerAttackState

@export var animation_name: String

@export var hitbox_collision_shapes : Array[HitboxCollision] = []

var attack_finished := false

# This class handles the following:
# - Have variables that hold move frame data and animation names
# - Connect animation signals to disable / enable hitboxes automatically
	
func player_state_ready():
	assert(len(hitbox_collision_shapes) > 0, name + ": Falta agregar colisiones")
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
		for hitbox_collision: HitboxCollision in hitbox_collision_shapes:
			if(player.player_animations.frame == hitbox_collision.start_frame):
				hitbox_collision.set_deferred("disabled", false)
			if(player.player_animations.frame == hitbox_collision.end_frame):
				hitbox_collision.set_deferred("disabled", true)

# Override in children
func handle_attack_finished_transitions() -> void:
	pass

func handle_attack_transitions() -> void:
	pass

# Override the transition function for the attack state to disable collisions when changing state
func transition_to(new_state: String, data := {}) -> void:
	for hitbox_collision in hitbox_collision_shapes:
		hitbox_collision.set_deferred("disabled", true)
	s_finished.emit(new_state, data)
