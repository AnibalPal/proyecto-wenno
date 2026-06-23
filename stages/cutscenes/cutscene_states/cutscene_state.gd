class_name CutsceneState
extends Node

@onready var cutscene_state_manager := $".."
var cutscene_entity : CharacterEntity
var should_end := false

func _ready() -> void:
	await owner.ready
	cutscene_entity = owner

func cutscene_state_enter(_data := {}) -> void:
	check_if_end(_data)
	enter(_data)

func check_if_end(_data := {}) -> void:
	if(_data.has("end")):
		should_end = _data["end"]

# Override
func enter(_data := {}) -> void:
	pass

# Override
func cutscene_state_process(_delta: float) -> void:
	pass

# Override
func cutscene_state_physics_process(_delta: float) -> void:
	pass

func end_move() -> void:
	reset_vars()
	if(should_end):
		cutscene_state_manager.end()
	else:
		cutscene_state_manager.cutscene_transition_to(cutscene_state_manager.IDLE)

# Override
func reset_vars() -> void:
	pass
