class_name CutsceneState
extends State

@onready var cutscene_state_machine := $".."
var cutscene_entity : CharacterEntity
var should_end := false

func _ready() -> void:
	await owner.ready
	cutscene_entity = owner

func check_if_end(_data := {}) -> void:
	if(_data.has("end")):
		should_end = _data["end"]

func enter(_data := {}) -> void:
	check_if_end(_data)
	cutscene_state_enter(_data)

# Override
func cutscene_state_enter(_data := {}) -> void:
	pass

func end_move() -> void:
	reset_vars()
	if(should_end):
		should_end = false
		cutscene_state_machine.end_cutscene_mode()
	else:
		cutscene_state_machine.s_action_complete.emit()
		cutscene_state_machine.transition_to_next_state(cutscene_state_machine.IDLE)

# Override
func reset_vars() -> void:
	pass
