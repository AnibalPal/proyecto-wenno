@tool
extends EnemyState

var slide_forward := false

func enter(_data: Dictionary) -> void:
	enemy.stop()
	enemy.sprite_animations.play("bite")
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		if(slide_forward):
			enemy.move_forward(enemy.speed * 2)
		handle_transitions()
		enemy.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	slide_forward = false

# Transitions via signals here
func _on_sprite_animations_frame_changed() -> void:
	if(state_machine.current_state.name == state_machine.ATTACK_1):
		if(enemy.sprite_animations.animation == "bite"):
			if(enemy.sprite_animations.frame == 1):
				slide_forward = true
			else:
				slide_forward = false

func _on_sprite_animations_animation_finished() -> void:
	if(state_machine.current_state.name == state_machine.ATTACK_1):
		if(enemy.sprite_animations.animation == "bite"):
			transition_to(state_machine.ACTIVE)
