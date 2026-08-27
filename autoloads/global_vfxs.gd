extends Node

@export_group("Hitstop vars")
@export var time_scale := 0.05
@export var stop_duration := 0.2

func hitstop(duration := stop_duration) -> void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
