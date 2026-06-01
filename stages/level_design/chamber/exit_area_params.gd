class_name ChamberExit
extends Area2D

@export var next_chamber_path := ""

func _ready() -> void:
	assert(next_chamber_path, "Exit " + name + ": No next chamber path set!")
