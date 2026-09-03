@tool
extends EnemyState

@onready var energy_reward: SpiritEnergySpawner = $"../../ShouldNotRotate/EnergyReward"
@onready var death_vfx: AnimationPlayer = $"../../VFXs/DeathVFX"

func enter(_data: Dictionary) -> void:
	death_vfx.play("death")
	energy_reward.reparent(get_tree().root)
	energy_reward.begin(owner.player_ref)
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

func _on_death_vfx_animation_finished(anim_name: StringName) -> void:
	if(state_machine.current_state.name == state_machine.DEATH):
		if(anim_name == "death"):
			state_machine.process_active = false
