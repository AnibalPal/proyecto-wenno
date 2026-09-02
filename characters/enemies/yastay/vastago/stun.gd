@tool
extends EnemyState

@onready var duration: Timer = $Duration

func enter(_data: Dictionary) -> void:
	enemy.sprite_animations.play("stun")
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		handle_transitions()
		enemy.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	enemy.counter_hit_state = false
	duration.start()

# Transitions via signals here
func _on_duration_timeout() -> void:
	if(state_machine.current_state.name == state_machine.STUN):
		enemy.stamina = enemy.initial_stamina
		transition_to(state_machine.ACTIVE)
