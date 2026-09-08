@tool
class_name NPCBase
extends CharacterEntity

@onready var cutscene_state_machine: BaseCutsceneStateMachine = $CutsceneStateMachine
@export var speed := 200
@export var gravity := 0

var entity_animations = null

func enter_cutscene_mode() -> void:
	cutscene_state_machine.activate_process()
	cutscene_state_machine.transition_to_next_state(cutscene_state_machine.IDLE)
	
func exit_cutscene_mode() -> void:
	cutscene_state_machine.deactivate_process()

func enable_gravity(_delta: float):
	velocity.y += gravity * _delta

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	GlobalTransitionEffects.fade_in()
	GlobalVFXs.hitstop(2.0)
	
	# Remove all connected functions for the global transition effects to avoid issues
	for connection in GlobalTransitionEffects.s_transition_finished.get_connections():
		GlobalTransitionEffects.s_transition_finished.disconnect(connection["callable"])
	
	GlobalTransitionEffects.s_transition_finished.connect(game_complete)

func game_complete(effect_name := "fade_in") -> void:
	if(effect_name == "fade_in"):
		GlobalTransitionEffects.fade_out()
		get_tree().change_scene_to_file("res://postulacion_fondo_2026/main_menu_postulacion_fondo.tscn")
