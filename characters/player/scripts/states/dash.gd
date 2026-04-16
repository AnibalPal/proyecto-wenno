@tool
extends PlayerState

func enter(_data: Dictionary) -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		player.velocity.y += player.gravity * _delta
		player.move_and_slide()
