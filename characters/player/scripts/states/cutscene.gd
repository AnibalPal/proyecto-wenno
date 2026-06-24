@tool
extends PlayerState

const IDLE := "Idle"
const MOVERIGHT := "MoveRight"
const MOVELEFT := "MoveLeft"
const MOVEY := "MoveY"
const JUMP := "Jump"
const FALL := "Fall"

# In this state, the player is controlled externally by the engine

@onready var player_hurtbox: PlayerHurtbox = $"../../ShouldRotate/Hurtbox"
@onready var player_trigger_collision: CollisionShape2D = $"../../ShouldRotate/PlayerTrigger/CollisionShape2D"
@onready var move_duration: Timer = $MoveDuration

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

func execute_cutscene_step(action: Enums.CutsceneActions, step_data := {}) -> void:
	var action_extra_data = step_data["data"] if step_data.has("data") else {}
	# Transform available cutscene actions for the player
	match action:
		Enums.CutsceneActions.MOVE:
			cutscene_transition_to(MOVERIGHT, action_extra_data)
		Enums.CutsceneActions.TALK:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION TALK")
		Enums.CutsceneActions.ANIMATION:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION ANIMATION")		
		Enums.CutsceneActions.WAIT:
			print("PLAYER CUTSCENE PENDING IMPLEMENTATION WAIT")		
		_:
			print("PLAYER CUTSCENE ACTION NOT FOUND: %s"% action)

func _on_move_duration_timeout() -> void:
	player.velocity.x = 0
	if(trigger_end):
		end()
