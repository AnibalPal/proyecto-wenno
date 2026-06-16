class_name CutsceneManager
extends Node2D

@onready var player: Player = $"../Player"

# The type is cutscene or null
var playing_cutscene : Variant = null

func prepare_cutscene_areas(chamber_node: Chamber) -> void:
	# Connect the cutscene signals with start cutscene
	var chamber_cutscene_node = chamber_node.get_node_or_null("Cutscenes")
	if(chamber_cutscene_node):
		if(chamber_cutscene_node.get_child_count() > 0):
			for child: Cutscene in chamber_cutscene_node.get_children():
				child.s_start_cutscene.connect(start_cutscene)

func start_cutscene(cutscene_id: String) -> void:
	# Check if the cutscene is not already seen by the player, then run it.
	# Set the player state to cutscene, then move as requested by the current cutscene
	# player.state_machine.transition_to_next_state(player.state_machine.state_data.CUTSCENE)
	print("START CUTSCENE: %s"%cutscene_id)
	# Revert to player control
	# player.state_machine.transition_to_next_state(player.state_machine.state_data.IDLE)
	
