class_name Stage
extends Node2D

# NOTE: a stage is composed of many chambers

@export var stage_id := ""
@export var initial_chamber_path := ""
@export var initial_entry_name := ""

@onready var player: Player = $Player
@onready var cutscene_manager: CutsceneManager = $CutsceneManager
@onready var current_chamber: Node2D = $CurrentChamber
@onready var fade_effect: CanvasLayer = $FadeEffect
@onready var screen_vfx_animation_player: AnimationPlayer = $FadeEffect/ScreenVFXanimationPlayer

var current_chamber_path := ""
var current_entry_name := ""

func _ready() -> void:
	assert(stage_id, "No stage id set!")
	assert(initial_chamber_path, stage_id + ": No inital chamber path set!")
	PlayerData.s_update_player_status.emit("current_stage_id", stage_id)
	var map_tab_node = player.find_child("MapTab")
	map_tab_node.load_stage_map()
	fade_effect.show()
	current_chamber_path = initial_chamber_path
	current_entry_name = initial_entry_name
	start_fade_out()
	call_deferred("load_chamber")

func set_player_move_direction(direction: String, end_cutscene:= false):
	match direction:
		"UP":
			player.cutscene_state_machine.transition_to_next_state("MoveUp", {
				"y": player.global_position.x - 50,
				"end": end_cutscene
			})
		"RIGHT":
			player.cutscene_state_machine.transition_to_next_state("Move", {
				"x": player.global_position.x + 120,
				"end": end_cutscene
			})
			#player.state_machine.current_state.move_right(end_cutscene)
		"DOWN":
			player.cutscene_state_machine.transition_to_next_state("Fall", {
				"end": end_cutscene
			})
		"LEFT":
			player.cutscene_state_machine.transition_to_next_state("Move", {
				"x": player.global_position.x - 120,
				"end": end_cutscene
			})
		"NONE":
			# TODO CREATE THE "ANIMATION" CUTSCENE STATE AND ADD IT HERE
			player.cutscene_state_machine.transition_to_next_state("Move", {
				"x": player.global_position.x,
				"end": end_cutscene
			})
		_:
			print("Unrecognized direction: " + direction)

func start_fade_out() -> void:
	screen_vfx_animation_player.play("fade_out")

func start_fade_in() -> void:
	screen_vfx_animation_player.play("fade_in")

func start_next_chamber_change(chamber_path: String, entry_name: String, direction: String) -> void:
	current_chamber_path = chamber_path
	current_entry_name = entry_name
	
	player.enter_cutscene_mode()
	if(player.cutscene_state_machine.process_active):
		set_player_move_direction(direction)	
	start_fade_in()

func remove_chamber() -> void:
	assert(current_chamber.get_child_count() <= 1, "Current stage must have at most one child only that represents the current chamber")
	# Remove older chamber if any
	if(current_chamber.get_child_count() > 0):
		var current_chamber_node = current_chamber.get_child(0)
		assert(current_chamber_node as Chamber, "Stage Manager: Current node is not of type Chamber")
		current_chamber_node.queue_free()	
	start_fade_out()
		
func load_chamber() -> void:	
	# Add new chamber
	var chamber_packed_scene = load(current_chamber_path)
	var chamber_instance: Chamber = chamber_packed_scene.instantiate()
	chamber_instance.remove_debug_player()
	PlayerData.s_update_map_progression.emit(stage_id, chamber_instance.id, "visited", true)
	PlayerData.s_update_player_status.emit("current_chamber_id", chamber_instance.id)
	# Need to call deferred because godot things
	call_deferred("add_chamber_node", chamber_instance, current_entry_name)

func add_chamber_node(chamber_instance: Chamber, entry_name: String) -> void:
	current_chamber.add_child(chamber_instance)
	chamber_instance.s_change_chamber.connect(start_next_chamber_change)
	cutscene_manager.prepare_cutscene_areas(chamber_instance)
	# Place player in the stage's player position node
	var new_entry_node = chamber_instance.get_entry_node(entry_name)
	assert(new_entry_node, "Error getting the player pos in the next chamber, make sure the name of the entrypoint exists, expected name: " + entry_name)
	player.global_position = new_entry_node.global_position
	player.enter_cutscene_mode()
	if(player.cutscene_state_machine.process_active):
		set_player_move_direction(new_entry_node.direction, true)

func _on_screen_vf_xanimation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "fade_in"):
		remove_chamber()
		call_deferred("load_chamber")
