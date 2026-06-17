class_name CutsceneManager
extends Node2D

@onready var player: Player = $"../Player"

var step_running := false

# The type is cutscene or null
var currently_playing_cutscene_node : Variant = null

func _process(_delta: float) -> void:
	if(currently_playing_cutscene_node):
		# Handle cutscene inputs to advance dialogue or animations
		if(Input.is_action_just_pressed("cutscene_next")):
			var cutscene_step_data = currently_playing_cutscene_node.get_next()
			if(cutscene_step_data):
				execute_step(cutscene_step_data)
			else:
				end_cutscene()

func prepare_cutscene_areas(chamber_node: Chamber) -> void:
	# Connect the cutscene signals with start cutscene
	var chamber_cutscene_node = chamber_node.get_node_or_null("Cutscenes")
	if(chamber_cutscene_node):
		if(chamber_cutscene_node.get_child_count() > 0):
			for child: Cutscene in chamber_cutscene_node.get_children():
				child.s_start_cutscene.connect(start_cutscene)

func start_cutscene(cutscene_id: String, cutscene_node: Cutscene) -> void:
	# Check if the cutscene is not already seen by the player, then run it.
	# Set the game mode to "cutscene" mode, this would allow the player to continue the 
	# cutscene by pressing a button or skip it with the start button
	currently_playing_cutscene_node = cutscene_node
	# Set the player state to cutscene, then move as requested by the current cutscene
	player.state_machine.transition_to_next_state(player.state_machine.state_data.CUTSCENE, {"stop": true})
	# Should also hide UI
	print("START CUTSCENE: %s"%cutscene_id)

func execute_step(steps := []) -> void:
	for step_data in steps:
		if(step_data["entity"] == "player"):
			pass
		else:
			var step_extra_data = step_data["data"] if step_data.has("data") else {}
			currently_playing_cutscene_node.execute(step_data["entity"], step_data["action"], step_extra_data)

func end_cutscene() -> void:
	currently_playing_cutscene_node = null
	player.state_machine.transition_to_next_state(player.state_machine.state_data.IDLE)
