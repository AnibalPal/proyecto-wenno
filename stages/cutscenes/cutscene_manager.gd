class_name CutsceneManager
extends Node2D

@onready var current_stage: Stage = $".."
@onready var player: Player = $"../Player"

# The type is cutscene or null
var currently_playing_cutscene_node : Variant = null

var player_step_completed := true
var cutscene_entitites_step_completed := true

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
				child.s_step_complete.connect(on_cutscene_step_complete)

func execute_step(steps := []) -> void:
	for action in steps:
		if(action.entity == "player"):
			player_step_completed = false
			player.state_machine.current_state.execute_cutscene_step(action.action, action.data)
		else:
			cutscene_entitites_step_completed = false
			currently_playing_cutscene_node.add_step_action(action)
	currently_playing_cutscene_node.execute()

func end_cutscene() -> void:
	#TODO: Maybe clean this in some other way
	# Update cutscene state to be seen
	PlayerData.s_update_cutscene_state.emit(currently_playing_cutscene_node.id)
	currently_playing_cutscene_node.cutscene_complete()
	currently_playing_cutscene_node = null
	player_step_completed = true
	cutscene_entitites_step_completed = true
	if(player.state_machine.current_state.name == "Cutscene"):
		player.state_machine.current_state.s_action_complete.disconnect(on_player_step_complete)
		player.state_machine.current_state.end()
	else:
		print("PLAYER WAS NOT IN CUTSCENE STATE WHEN TRYING TO END CUTSCENE")

func start_cutscene(cutscene_id: String, cutscene_node: Cutscene) -> void:
	# Check if the cutscene is not already seen by the player, then run it.
	# Set the game mode to "cutscene" mode, this would allow the player to continue the 
	# cutscene by pressing a button or skip it with the start button
	currently_playing_cutscene_node = cutscene_node
	var cutscene_step_data = currently_playing_cutscene_node.get_next()
	# Set the player state to cutscene, then move as requested by the current cutscene
	player.state_machine.transition_to_next_state(player.state_machine.state_data.CUTSCENE)
	player.state_machine.current_state.s_action_complete.connect(on_player_step_complete)
	if(cutscene_step_data):
		execute_step(cutscene_step_data.actions)
	# Should also hide UI
	print("START CUTSCENE: %s"%cutscene_id)

func on_player_step_complete() -> void:
	player_step_completed = true
	on_step_complete()

func on_cutscene_step_complete() -> void:
	cutscene_entitites_step_completed = true
	on_step_complete()

func on_step_complete() -> void:
	if(currently_playing_cutscene_node):
		if(player_step_completed and cutscene_entitites_step_completed):
			var cutscene_step_data = currently_playing_cutscene_node.get_next()
			if(cutscene_step_data):
				execute_step(cutscene_step_data.actions)
			else:
				end_cutscene()
