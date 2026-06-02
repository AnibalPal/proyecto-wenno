class_name ChamberEntry
extends Node2D

@export_enum("UP", "RIGHT", "DOWN", "LEFT") var direction := ""

func _ready() -> void:
	assert(direction, "Entrypoint %s: No direction set" % name)
