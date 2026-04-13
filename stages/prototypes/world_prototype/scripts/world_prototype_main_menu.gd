extends Control


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/world_prototype/scenes/world_prototype.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
