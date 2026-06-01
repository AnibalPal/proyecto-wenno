class_name Stage
extends Node2D

# NOTE: a stage is composed of many chambers

@export var stage_id := ""
@export var initial_chamber_path := ""
@export var initial_entry_name := ""

@onready var player: Player = $Player
@onready var current_chamber: Node2D = $CurrentChamber

func _ready() -> void:
	assert(stage_id, "No stage id set!")
	assert(initial_chamber_path, stage_id + ": No inital chamber path set!")
	call_deferred("load_chamber", initial_chamber_path, initial_entry_name)

func add_chamber_node(chamber_instance: Chamber, entry_name: String) -> void:
	current_chamber.add_child(chamber_instance)
	chamber_instance.s_change_chamber.connect(load_chamber)
	# Place player in the stage's player position node
	var new_pos = chamber_instance.get_entry_position(entry_name)
	assert(new_pos, "Error getting the player pos in the next chamber, make sure the name of the entrypoint exists, expected name: " + entry_name)
	player.global_position = new_pos
	
		

func load_chamber(chamber_path: String, entry_name: String) -> void:	
	assert(current_chamber.get_child_count() <= 1, "Current stage must have at most one child only that represents the current chamber")
	# Remove older chamber if any
	if(current_chamber.get_child_count() > 0):
		var current_chamber_node = current_chamber.get_child(0)
		assert(current_chamber_node as Chamber, "Stage Manager: Current node is not of type Chamber")
		current_chamber_node.queue_free()	
	# Add new stage
	var chamber_packed_scene = load(chamber_path)
	var chamber_instance: Chamber = chamber_packed_scene.instantiate()
	# Need to call deferred because godot things
	call_deferred("add_chamber_node", chamber_instance, entry_name)
