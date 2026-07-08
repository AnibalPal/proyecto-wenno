class_name MapManager
extends MarginContainer

const MAP_STRING_TEMPLATE := "res://stages/main_stages/%s/map/%s_map.tscn"

@onready var current_map_title: Label = $Map/Content/MapArea/MapAreaBorder/ContentMargin/MapContent/CurrentMapTitle
@onready var current_map: Control = $Map/Content/MapArea/MapAreaBorder/ContentMargin/MapContent/CurrentMap

func _ready() -> void:
	PlayerData.s_update_map_progression.connect(update_map_ui)

func load_stage_map():
	var current_stage_id: String = PlayerData.player_progression["status"]["current_stage_id"]
	current_map_title.text = current_stage_id
	var packed_scene_map = load(MAP_STRING_TEMPLATE % [current_stage_id, current_stage_id])
	var map_instance = packed_scene_map.instantiate()
	current_map.add_child(map_instance)

func update_map_ui(_stage_id: String, _chamber_id: String, _key: String, _value: Variant):
	if(current_map.get_child_count() >= 1):
		var current_map_node: MapUI = current_map.get_child(0)
		current_map_node.call_deferred("update_map_ui")
