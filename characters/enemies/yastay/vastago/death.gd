@tool
extends EnemyState

@onready var death_vfx: AnimationPlayer = $"../../VFXs/DeathVFX"

func enter(_data: Dictionary) -> void:
	death_vfx.play("death")
	enemy.disable_hurtboxes()
	enemy.disable_hitboxes()
	enemy.sprite_animations.play("death")
	enemy.velocity = Vector2.ZERO
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		# enemy.enable_gravity(_delta)
		handle_transitions()
		enemy.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pass

# Transitions via signals here
func _on_sprite_animations_animation_finished() -> void:
	if(enemy.sprite_animations.animation == "death"):
		queue_free()
