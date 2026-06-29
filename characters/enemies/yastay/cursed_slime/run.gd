@tool
extends EnemyState

func enter(_data: Dictionary) -> void:
	enemy.sprite_animations.play("run")
	enemy.move_forward(enemy.speed)

func state_process(_delta: float) -> void:
	enemy.enable_attack_detection()

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.move_forward(enemy.speed)
		enemy.enable_gravity(_delta)
		if(enemy.wall_detection.is_colliding()):
			enemy.turn_around()
		if(enemy.is_on_floor() and !enemy.floor_detection.is_colliding()):
			enemy.turn_around()
		enemy.move_and_slide()

# Transitions via signals here
func _on_attack_in_range_detection_area_entered(_area: Area2D) -> void:
	state_machine.transition_to_next_state(state_machine.ATTACK)
