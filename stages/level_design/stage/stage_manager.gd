class_name Stage
extends Node2D

# NOTE: a stage is composed of many chambers

@export var stage_id := ""
@export var initial_chamber_path := ""

@onready var player: Player = $Player
@onready var current_chamber: Node2D = $CurrentChamber

func _ready() -> void:
	assert(stage_id, "No stage id set!")
	assert(initial_chamber_path, stage_id + ": No inital chamber path set!")
	call_deferred("load_chamber", initial_chamber_path)

func add_chamber_node(chamber_instance: Node) -> void:
	current_chamber.add_child(chamber_instance)
	# Place player in the stage's player position node
	player.global_position = chamber_instance.start_position_node.global_position

func load_chamber(chamber_path: String) -> void:	
	assert(current_chamber.get_child_count() <= 1, "Current stage must have at most one child only that represents the current chamber")
	# Remove older chamber if any
	if(current_chamber.get_child_count() > 0):
		var current_chamber_node = current_chamber.get_child(0)
		assert(current_chamber_node as Chamber, "Stage Manager: Current node is not of type Chamber")
		current_chamber_node.queue_free()	
	# Add new stage
	var chamber_packed_scene = load(chamber_path)
	var chamber_instance: Chamber = chamber_packed_scene.instantiate()
	chamber_instance.s_change_chamber.connect(load_chamber)
	# Need to call deferred because godot things
	call_deferred("add_chamber_node", chamber_instance)
