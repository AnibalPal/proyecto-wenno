extends Area2D
class_name Box

@export var interaction_priority := 0 # lowest priority

func disable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", true)	

func enable() -> void:
	for collision in get_children():
		collision.set_deferred("disabled", false)

func get_interaction_priority() -> int:
	return interaction_priority
