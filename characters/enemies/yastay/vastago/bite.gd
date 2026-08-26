@tool
extends EnemyState

var slide_forward := false
var deceleration_rate := 0.9

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
			enemy.velocity.x *= deceleration_rate
		if(Helpers.is_equal_custom(enemy.velocity.x, 0.0, 5.0)):
			enemy.velocity.x = 0
			slide_forward = false
		handle_transitions()
		enemy.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	slide_forward = false

# Transitions via signals here
func _on_sprite_animations_frame_changed() -> void:
	if(state_machine.current_state.name == state_machine.BITE):
		if(enemy.sprite_animations.animation == "bite"):
			if(enemy.sprite_animations.frame == 1):
				enemy.move_forward(enemy.speed * 3)
				slide_forward = true
			else:
				slide_forward = false

func _on_sprite_animations_animation_finished() -> void:
	if(state_machine.current_state.name == state_machine.BITE):
		if(enemy.sprite_animations.animation == "bite"):
			transition_to(state_machine.RECOVERY)
