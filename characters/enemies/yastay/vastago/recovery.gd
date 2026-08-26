@tool
extends EnemyState

@onready var attack_cooldown: Timer = $AttackCooldown

func enter(_data: Dictionary) -> void:
	enemy.stop()
	attack_cooldown.start()
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
	pass

# Transitions via signals here
func _on_attack_cooldown_timeout() -> void:
	if(state_machine.current_state.name == state_machine.RECOVERY):	
		transition_to(state_machine.ACTIVE)
