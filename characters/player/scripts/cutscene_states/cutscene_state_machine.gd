class_name PlayerCutsceneStateMachine
extends CutsceneStateMachine

const IDLE := "Idle"
const MOVE := "Move"

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
		Enums.CutsceneCommonActions.MOVE:
			transition_to_next_state(MOVE, step_data)
		Enums.CutsceneCommonActions.TALK:
			instantiate_dialogue_bubble(step_data["text"])
		Enums.CutsceneCommonActions.ANIMATION:
			print("PLAYER PENDING IMPLEMENTATION ANIMATION")		
		Enums.CutsceneCommonActions.WAIT:
			print("PLAYER PENDING IMPLEMENTATION WAIT")		
		_:
			print("PLAYER ACTION NOT FOUND: %s"% action)
