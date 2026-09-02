@tool
extends EnemyState

var player_position = null

var clash_slowdown_rate := 0.9

func enter(_data: Dictionary) -> void:
	reset_state()
	enemy.sprite_animations.play("reaction")
	if(_data.has("player_position")):
		player_position = _data["player_position"]
		enemy.turn_towards(player_position)
		enemy.move_backwards(enemy.speed * 2)

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		enemy.velocity.x *= clash_slowdown_rate
		handle_transitions()
		enemy.move_and_slide()

func handle_transitions() -> void:
	if(Helpers.is_equal_custom(enemy.velocity.x, 0.0, 5) and enemy.is_on_floor()):
		if(enemy.stamina <= 0):
			transition_to(state_machine.STUN)
		else:
			transition_to(state_machine.ACTIVE)

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	enemy.counter_hit_state = false
	player_position = null
	enemy.disable_hitboxes()

# Transitions via signals here
