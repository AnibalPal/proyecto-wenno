@tool
extends EnemyState

var jump_direction := 0

func enter(_data: Dictionary) -> void:
	if(_data.has("jump_direction")):
		jump_direction = _data["jump_direction"]
	else:
		jump_direction = 0
	enemy.stop()
	enemy.sprite_animations.play("jump_start")
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta, 2)
		handle_transitions()
		enemy.move_and_slide()
		if(enemy.is_on_floor() and enemy.sprite_animations.animation == "jump_hold"):
			enemy.sprite_animations.play("jump_end")
			transition_to(state_machine.RECOVERY)

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pass

# Transitions via signals here
func _on_sprite_animations_animation_finished() -> void:
	if(state_machine.current_state.name == state_machine.JUMP):
		if(enemy.sprite_animations.animation == "jump_start"):
			enemy.velocity.x = 150 * jump_direction
			enemy.velocity.y = -300
			enemy.sprite_animations.play("jump_hold")
