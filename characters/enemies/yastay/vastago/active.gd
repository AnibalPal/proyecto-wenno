@tool
extends EnemyState

@onready var vastago: Vastago = $"../.."
@onready var jump_cooldown: Timer = $JumpCooldown

var jump_available := true
var player_ref = null

func enter(_data: Dictionary) -> void:
	enemy.counter_hit_state = false
	enemy.disable_hitboxes()
	if(player_ref):
		enemy.turn_towards(player_ref.global_position)
	if(_data.has("player")):
		player_ref = _data["player"]
		owner.player_ref = _data["player"]
	enemy.move_forward(vastago.speed)
	vastago.sprite_animations.play("run")
	select_attack()
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
	var distance_to_player = abs(vastago.global_position.distance_to(player_ref.global_position))
	if(distance_to_player < 180 and distance_to_player > 120):
		if(jump_available):
			vastago.turn_towards(player_ref.global_position)
			jump()
	elif(distance_to_player <= 120):
		vastago.turn_towards(player_ref.global_position)
		bite()
		

func bite() -> void:
	transition_to(state_machine.BITE)

func jump() -> void:
	jump_available = false
	jump_cooldown.start()
	transition_to(state_machine.JUMP, {
		"jump_direction": sign(enemy.global_position.direction_to(player_ref.global_position).x)
	})

# Transitions via signals here
func _on_chase_area_area_exited(_area: Area2D) -> void:
	if(state_machine.current_state == state_machine.ACTIVE):			
		player_ref = null
		transition_to(state_machine.PASSIVE)

func _on_jump_cooldown_timeout() -> void:
	jump_available = true
