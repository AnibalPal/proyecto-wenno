class_name PlayerStateMachine
extends StateMachine

var state_data = PlayerStateData

func _ready() -> void:
	check_state_machine()
	state_machine_ready()

func is_transition_active(from: String, to: String) -> bool:
	print(from, to)
	if(state_data.transitions[from].has(to)):
		return state_data.transitions[from][to]
	else:
		return false

# NOTE: override from StateMachine to add transition check
func transition_to_next_state(next_state_path: String, data := {}) -> void:
	if(current_state):
		if(is_transition_active(current_state.name, next_state_path)):
			current_state = get_node(next_state_path)
			current_state.enter(data)

func disable_state(to_disable: String) -> void:
	# Disable all states that point to the to_disable state
	for from_state in state_data.transitions:
		if state_data.transitions[from_state].has(to_disable):
			state_data.transitions[from_state][to_disable] = false
	# Disable all transitions form the state to disable
	for to_state in state_data.transitions[to_disable]:
		state_data.transitions[to_disable][to_state] = false

func check_state_machine() -> void:
	# Disable transitions depending on state's active variable
	for child: PlayerState in get_children():
		assert(child is PlayerState, "ERROR: Child is not of type PlayerState, make sure that all the PlayerStateMachine children are of type PlayerState")
		if(!child.active):
			disable_state(child.name)
