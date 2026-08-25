@tool
extends EnemyState

@onready var vastago: Vastago = $"../.."

var player_ref = null

func enter(_data: Dictionary) -> void:
	if(_data.has("player")):
		player_ref = _data["player"]
	enemy.move_forward(vastago.speed)
	vastago.sprite_animations.play("run")
	reset_state()

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		handle_transitions()
		select_attack()
		enemy.move_and_slide()

func handle_transitions() -> void:
	pass

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	pass

func select_attack() -> void:
	#if(abs(vastago.global_position.distance_to(player_ref.global_position)) < 200):
		#vastago.turn_towards(player_ref.global_position)
		#jump()
	if(abs(enemy.global_position.distance_to(player_ref.global_position)) < 100):
		vastago.turn_towards(player_ref.global_position)
		bite()
		

func bite() -> void:
	transition_to(state_machine.ATTACK_1)

func jump() -> void:
	pass

# Transitions via signals here
func _on_chase_area_area_exited(_area: Area2D) -> void:
	if(state_machine.current_state == state_machine.ACTIVE):			
		player_ref = null
		transition_to(state_machine.PASSIVE)
