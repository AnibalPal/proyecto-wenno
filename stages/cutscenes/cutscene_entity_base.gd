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
