@tool
extends PlayerState

# In this state, the player is controlled externally by the engine

const DIALOGUE_BUBBLE_Y_OFFSET := 10

const IDLE := "Idle"
const MOVERIGHT := "MoveRight"
const MOVELEFT := "MoveLeft"
const MOVEY := "MoveY"
const JUMP := "Jump"
const FALL := "Fall"

@export var dialogue_bubble : PackedScene

@onready var cutscene_bubble_anchor: Node2D = $"../../ShouldNotRotate/CutsceneBubbleAnchor"
@onready var player_hurtbox: PlayerHurtbox = $"../../ShouldRotate/Hurtbox"
@onready var player_trigger_collision: CollisionShape2D = $"../../ShouldRotate/PlayerTrigger/CollisionShape2D"
@onready var move_duration: Timer = $MoveDuration

signal s_action_complete

var has_gravity := true
var trigger_end := false

# CutsceneState or null
var current_state_node : Variant = null

func enter(_data: Dictionary) -> void:
	player_trigger_collision.set_deferred("disabled", true)
	player_hurtbox.disable()
	cutscene_transition_to(IDLE)

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	if(active):
		if(current_state_node):
			current_state_node.cutscene_state_physics_process(_delta)
			player.move_and_slide()	

# Used in other nodes to change behavior
func cutscene_transition_to(state_name: String, data := {}) -> void:
	current_state_node = get_node(state_name)
	current_state_node.cutscene_state_enter(data)

func end() -> void:
	player_trigger_collision.set_deferred("disabled", false)
	player_hurtbox.enable()
	current_state_node = null
	if(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		transition_to(state_data.RUN)
	else:
		transition_to(state_data.IDLE)

func execute_cutscene_step(action: Enums.CutsceneCommonActions, step_data = {}) -> void:
	# Transform available cutscene actions for the player
	match action:
		Enums.CutsceneCommonActions.MOVE:
			if(player.global_position.x < step_data["x"]):
				cutscene_transition_to(MOVERIGHT, step_data)
			else:
				cutscene_transition_to(MOVELEFT, step_data)
		Enums.CutsceneCommonActions.TALK:
			instantiate_dialogue_bubble(step_data["text"])
		Enums.CutsceneCommonActions.ANIMATION:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION ANIMATION")		
		Enums.CutsceneCommonActions.WAIT:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION WAIT")		
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

func _on_move_duration_timeout() -> void:
	player.velocity.x = 0
	if(trigger_end):
		end()
