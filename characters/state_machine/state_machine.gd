# Virtual State class, the functions here should be overridden in the proper state
class_name StateMachine
extends Node

@export var initial_state : State
@export var process_active := false

var current_state : State

func _ready() -> void:
	state_machine_ready()

func _process(delta: float) -> void:
	if(process_active):
		current_state.state_process(delta)

func _physics_process(delta: float) -> void:
	if(process_active):
		current_state.state_physics_process(delta)

func state_machine_ready():
	current_state = initial_state
	assert(current_state, "No initial state set")
	for state_node: State in get_children():
		if(state_node):
			state_node.s_finished.connect(transition_to_next_state)

func transition_to_next_state(next_state_path: String, data := {}) -> void:
	current_state = get_node(next_state_path)
	current_state.enter(data)

func activate_process() -> void:
	process_active = true

func deactivate_process() -> void:
	process_active = false
	
