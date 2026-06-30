extends EnemyState

func enter(_data: Dictionary) -> void:
	enemy.velocity.x = 0
	enemy.sprite_animations.play("attack")

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		enemy.move_and_slide()

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pass

# Transitions via signals here

func _on_sprite_animations_animation_finished() -> void:
	if(enemy.sprite_animations.animation == "attack"):
		transition_to(state_machine.RUN)
