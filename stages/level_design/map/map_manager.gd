class_name MapManager
extends MarginContainer

@onready var current_map_title: Label = $Map/Content/MapArea/MapAreaBorder/ContentMargin/MapContent/CurrentMapTitle
@onready var current_map: Control = $Map/Content/MapArea/MapAreaBorder/ContentMargin/MapContent/CurrentMap

func _ready() -> void:
	call_deferred("load_stage_map")
	PlayerData.s_update_map_progression.connect(update_map_ui)

func load_stage_map():
	var current_stage_id: String = PlayerData.player_progression["status"]["current_stage_id"]
	current_map_title.text = current_stage_id
	var packed_scene_map = load("res://stages/maps/%s.tscn" % current_stage_id)
	var map_instance = packed_scene_map.instantiate()
	current_map.add_child(map_instance)

func update_map_ui(stage_id: String, chamber_id: String, key: String, value: Variant):
	pass
