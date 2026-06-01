class_name Stage
extends Node2D

# NOTE: a stage is composed of many chambers

@export var stage_id := ""
@export var initial_chamber_path := ""
@export var initial_entry_name := ""

@onready var player: Player = $Player
@onready var current_chamber: Node2D = $CurrentChamber
@onready var fade_effect: CanvasLayer = $FadeEffect
@onready var screen_vfx_animation_player: AnimationPlayer = $FadeEffect/ScreenVFXanimationPlayer

var current_chamber_path := ""
var current_entry_name := ""

func _ready() -> void:
	assert(stage_id, "No stage id set!")
	assert(initial_chamber_path, stage_id + ": No inital chamber path set!")
	fade_effect.show()
	current_chamber_path = initial_chamber_path
	current_entry_name = initial_entry_name
	start_fade_out()
	call_deferred("load_chamber")

func add_chamber_node(chamber_instance: Chamber, entry_name: String) -> void:
	current_chamber.add_child(chamber_instance)
	chamber_instance.s_change_chamber.connect(start_next_chamber_change)
	# Place player in the stage's player position node
	var new_pos = chamber_instance.get_entry_position(entry_name)
	assert(new_pos, "Error getting the player pos in the next chamber, make sure the name of the entrypoint exists, expected name: " + entry_name)
	player.global_position = new_pos

func start_fade_out() -> void:
	screen_vfx_animation_player.play("fade_out")

func start_fade_in() -> void:
	screen_vfx_animation_player.play("fade_in")

func start_next_chamber_change(chamber_path: String, entry_name: String) -> void:
	current_chamber_path = chamber_path
	current_entry_name = entry_name
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
	# Need to call deferred because godot things
	call_deferred("add_chamber_node", chamber_instance, current_entry_name)

func _on_screen_vf_xanimation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "fade_in"):
		remove_chamber()
		call_deferred("load_chamber")
