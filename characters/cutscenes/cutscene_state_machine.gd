class_name CutsceneStateMachine
extends StateMachine

# In this state, the player/enemy/npc is controlled externally by the CutsceneManager
const DIALOGUE_BUBBLE_Y_OFFSET := 10

@onready var cutscene_bubble_anchor: Node2D = $"../ShouldNotRotate/CutsceneBubbleAnchor"

@export var dialogue_bubble : PackedScene

@warning_ignore("unused_signal")
signal s_end_cutscene
@warning_ignore("unused_signal")
signal s_persist(entity : Node)
signal s_action_complete

# Override
func activate_state_machine() -> void:
	pass

# Override
func deactivate_state_machine() -> void:
	pass

# Override
func end_cutscene_mode():
	pass

# Override
func execute_cutscene_step(_action: Enums.CutsceneCommonActions, _step_data = {}) -> void:
	# Handle every possible case defined in the enum for actions depending
	# on the case, for example player actions, npc actions, etc.
	pass

# Helper functions
func instantiate_dialogue_bubble(text:= "", width := 240) -> void:
	var dialogue_bubble_instance : DialogueBubble = dialogue_bubble.instantiate()
	dialogue_bubble_instance.dialogue_text = text
	dialogue_bubble_instance.minimum_bubble_width = width
	dialogue_bubble_instance.global_position = Vector2(cutscene_bubble_anchor.global_position.x, cutscene_bubble_anchor.global_position.y - DIALOGUE_BUBBLE_Y_OFFSET)
	dialogue_bubble_instance.s_dialogue_complete.connect(on_dialogue_complete)
	get_tree().root.add_child(dialogue_bubble_instance)

func on_dialogue_complete() -> void:
	s_action_complete.emit()
