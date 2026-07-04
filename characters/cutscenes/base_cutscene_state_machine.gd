class_name BaseCutsceneStateMachine
extends CutsceneStateMachine

const IDLE := "Idle"
const MOVE := "Move"

@onready var entity: CharacterEntity = $".."

func activate_state_machine() -> void:
	transition_to_next_state(IDLE)
	activate_process()

func deactivate_state_machine() -> void:
	transition_to_next_state(IDLE)
	deactivate_process()

func end_cutscene_mode():
	s_end_cutscene.emit()

func execute_cutscene_step(action: Enums.CutsceneCommonActions, step_data = {}) -> void:
	# Transform available cutscene actions for the player
	# Move to cutscene state machine
	match action:
		Enums.CutsceneCommonActions.SHOW:
			entity.process_mode = Node.PROCESS_MODE_INHERIT
			entity.show()
			s_action_complete.emit()
		Enums.CutsceneCommonActions.MOVE:
			transition_to_next_state(MOVE, step_data)
		Enums.CutsceneCommonActions.TALK:
			instantiate_dialogue_bubble(step_data["text"])
		Enums.CutsceneCommonActions.ANIMATION:
			print("ENTITY ANIMATION PENDING IMPLEMENTATION ANIMATION")		
		Enums.CutsceneCommonActions.WAIT:
			print("ENTITY WAIT PENDING IMPLEMENTATION WAIT")
		Enums.CutsceneCommonActions.INSTANTIATE:
			s_persist.emit(entity)
			s_action_complete.emit()		
		_:
			print("CURSED SLIME ACTION NOT FOUND: %s"% action)
