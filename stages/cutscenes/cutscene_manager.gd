class_name CutsceneManager
extends Node2D

@onready var player: Player = $"../Player"

var step_running := false

# The type is cutscene or null
var currently_playing_cutscene_node : Variant = null
var dialogue_playing := false

func _process(_delta: float) -> void:
	if(currently_playing_cutscene_node):
		pass
		# Handle cutscene skip inputs and logic
	

func prepare_cutscene_areas(chamber_node: Chamber) -> void:
	# Connect the cutscene signals with start cutscene
	var chamber_cutscene_node = chamber_node.get_node_or_null("Cutscenes")
	if(chamber_cutscene_node):
		if(chamber_cutscene_node.get_child_count() > 0):
			for child: Cutscene in chamber_cutscene_node.get_children():
				child.s_start_cutscene.connect(start_cutscene)
				child.s_step_complete.connect(on_step_complete)

func start_cutscene(cutscene_id: String, cutscene_node: Cutscene) -> void:
	# Check if the cutscene is not already seen by the player, then run it.
	# Set the game mode to "cutscene" mode, this would allow the player to continue the 
	# cutscene by pressing a button or skip it with the start button
	currently_playing_cutscene_node = cutscene_node
	step_running = true
	var cutscene_step_data = currently_playing_cutscene_node.get_next()
	# Set the player state to cutscene, then move as requested by the current cutscene
	player.state_machine.transition_to_next_state(player.state_machine.state_data.CUTSCENE)
	if(cutscene_step_data):
		execute_step(cutscene_step_data)
	# Should also hide UI
	print("START CUTSCENE: %s"%cutscene_id)

func execute_step(steps := []) -> void:
	for step_data in steps:
		if(step_data["entity"] == "player"):
			player.state_machine.current_state.execute_cutscene_step(step_data["action"], step_data)
		else:
			currently_playing_cutscene_node.add_step_action(step_data)
	currently_playing_cutscene_node.execute()

func end_cutscene() -> void:
	#TODO: Maybe clean this in some other way
	currently_playing_cutscene_node.queue_free()
	currently_playing_cutscene_node = null
	if(player.state_machine.current_state.name == "Cutscene"):
		player.state_machine.current_state.end()
	else:
		print("PLAYER WAS NOT IN CUTSCENE STATE WHEN TRYING TO END CUTSCENE")

func on_step_complete() -> void:
	step_running = false
	var cutscene_step_data = currently_playing_cutscene_node.get_next()
	if(cutscene_step_data):
		execute_step(cutscene_step_data)
	else:
		end_cutscene()
