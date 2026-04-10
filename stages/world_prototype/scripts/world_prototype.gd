extends Node2D

func reset_game() -> void:
	get_tree().change_scene_to_file("res://stages/world_prototype/scenes/world_prototype_main_menu.tscn")

func _on_stage_complete_area_body_entered(_body: Node2D) -> void:
	call_deferred("reset_game")
