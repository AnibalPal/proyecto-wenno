class_name Box
extends Area2D

@export var interaction_priority := 0 # lowest priority

## Disables all collision shapes of this collisions box
func disable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", true)	

## Enables all collision shapes of this collisions box
func enable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", false)

func get_interaction_priority() -> int:
	return interaction_priority
