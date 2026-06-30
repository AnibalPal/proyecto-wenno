extends EnemyState

func enter(_data: Dictionary) -> void:
	if(_data.has("player_position")):
		enemy.turn_towards(_data["player_position"])
	else:
		print(owner.name + ": No player position to turn to when spawning!")
	enemy.enable_hurtboxes()
	enemy.disable_activation_detection()
	enemy.sprite_animations.play("spawn")

func state_physics_process(_delta: float) -> void:
	if(active):
		enemy.enable_gravity(_delta)
		enemy.move_and_slide()

func _on_sprite_animations_animation_finished() -> void:
	if(enemy.sprite_animations.animation == "spawn"):
		transition_to(state_machine.RUN)
