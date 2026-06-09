extends Node2D

func _ready() -> void:
	call_deferred("load_scene")

func load_scene():
	var packed = load("res://stages/maps/prototype.tscn")
	var instance = packed.instantiate()
	get_tree().root.add_child(instance)	
