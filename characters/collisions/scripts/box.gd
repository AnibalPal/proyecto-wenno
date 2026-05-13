class_name Box
extends Area2D

## Disables all collision shapes of this collisions box
func disable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", true)	

## Enables all collision shapes of this collisions box
func enable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", false)
