# Virtual State class, the functions here should be overriden in the proper state
class_name StateMachine
extends Node

@export var initial_state : PlayerState

var current_state : PlayerState

func _ready() -> void:
	current_state = initial_state
	assert(current_state, "No initial state set")
	for state_node: PlayerState in get_children():
		if(state_node):
			state_node.s_finished.connect(transition_to_next_state)
	if(current_state):
		current_state.state_ready()

func _process(delta: float) -> void:
	current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	current_state.state_physics_process(delta)

func transition_to_next_state(next_state_path: String, data := {}) -> void:
	current_state = get_node(next_state_path)
	current_state.enter(data)
