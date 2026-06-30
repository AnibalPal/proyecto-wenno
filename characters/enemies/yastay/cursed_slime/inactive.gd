extends EnemyState

func enter(_data: Dictionary) -> void:
	enemy.disable_hitboxes()
	enemy.disable_hurtboxes()
	enemy.disable_detections()
	enemy.enable_activation_detection()
	enemy.sprite_animations.play("passive")

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		enemy.move_and_slide()

# Transitions based on detections, should go below here
func _on_activate_detection_area_entered(_area: Area2D) -> void:
	transition_to(state_machine.SPAWN,{
		"player_position" : _area.global_position
	})
