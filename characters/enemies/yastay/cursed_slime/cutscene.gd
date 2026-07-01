extends EnemyState

# In this state, the player is controlled externally by the engine
const DIALOGUE_BUBBLE_Y_OFFSET := 10

const IDLE := "Idle"
const SPAWN := "Spawn"
const MOVERIGHT := "MoveRight"
const MOVELEFT := "MoveLeft"
const ATTACK := "Attack"

@export var dialogue_bubble : PackedScene

@onready var cutscene_bubble_anchor: Node2D = $"../../ShouldNotRotate/CutsceneBubbleAnchor"
@onready var enemy_hurtboxes: Node2D = $"../../ShouldRotate/Hurtboxes"

signal s_action_complete
signal s_persist(node: Node)

var has_gravity := true
var trigger_end := false

# CutsceneState or null
var current_state_node : Variant = null

func enter(_data: Dictionary) -> void:
	enemy.velocity.x = 0
	enemy.disable_detections()
	enemy.disable_hurtboxes()
	cutscene_transition_to(IDLE)

# Use if there are variables that should be reset when entering this state
func reset_state()  -> void:
	current_state_node = null

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(current_state_node):
			current_state_node.cutscene_state_physics_process(_delta)
			enemy.move_and_slide()	

# Used in other nodes to change behavior
func cutscene_transition_to(state_name: String, data := {}) -> void:
	current_state_node = get_node_or_null(state_name)
	assert(current_state_node, "No cutscene node with the name %s found" % state_name)
	current_state_node.cutscene_state_enter(data)


func end() -> void:
	enemy.enable_attack_detection()
	enemy.enable_hurtboxes()
	current_state_node = null
	transition_to(enemy.state_machine.RUN)

func execute_cutscene_step(action: Enums.CutsceneCommonActions, step_data = {}) -> void:
	# Transform available cutscene actions for the player
	match action:
		Enums.CutsceneCommonActions.SHOW:
			enemy.process_mode = Node.PROCESS_MODE_INHERIT
			enemy.show()
			s_action_complete.emit()
		Enums.CutsceneCommonActions.MOVE:
			if(enemy.global_position.x < step_data["x"]):
				cutscene_transition_to(MOVERIGHT, step_data)
			else:
				cutscene_transition_to(MOVELEFT, step_data)
		Enums.CutsceneCommonActions.TALK:
			instantiate_dialogue_bubble(step_data["text"])
		Enums.CutsceneCommonActions.ANIMATION:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION ANIMATION")		
		Enums.CutsceneCommonActions.WAIT:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION WAIT")		
		Enums.CutsceneCommonActions.INSTANTIATE:
			s_persist.emit(enemy)
			s_action_complete.emit()
		_:
			print("PLAYER CUTSCENE ACTION NOT FOUND: %s"% action)

# NOTE: Duplicate function in CutsceneEntityBase class
func instantiate_dialogue_bubble(text:= "", width := 240) -> void:
	var dialogue_bubble_instance : DialogueBubble = dialogue_bubble.instantiate()
	dialogue_bubble_instance.dialogue_text = text
	dialogue_bubble_instance.minimum_bubble_width = width
	dialogue_bubble_instance.global_position = Vector2(cutscene_bubble_anchor.global_position.x, cutscene_bubble_anchor.global_position.y - DIALOGUE_BUBBLE_Y_OFFSET)
	dialogue_bubble_instance.s_dialogue_complete.connect(on_dialogue_complete)
	get_tree().root.add_child(dialogue_bubble_instance)

func on_dialogue_complete() -> void:
	s_action_complete.emit()
