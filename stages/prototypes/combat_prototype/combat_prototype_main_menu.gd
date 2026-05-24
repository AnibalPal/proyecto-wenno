extends Control

func _ready() -> void:
	Settings.counter_state_aura = false

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://stages/prototypes/combat_prototype/stage1/combat_prototype_stage_1.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_check_box_pressed() -> void:
	Settings.counter_state_aura = !Settings.counter_state_aura
