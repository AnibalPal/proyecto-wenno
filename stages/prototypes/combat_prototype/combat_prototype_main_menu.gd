extends Control


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/prototypes/combat_prototype/stage1/combat_prototype_stage_1.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
