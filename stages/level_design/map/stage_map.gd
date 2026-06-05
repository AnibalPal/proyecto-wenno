class_name MapUI
extends Control

#@onready var up_open_wall: ColorRect = $Up/Open
#@onready var right_open_wall: ColorRect = $Right/Open
#@onready var down_open_wall: ColorRect = $Down/Open
#@onready var left_open_wall: ColorRect = $Left/Open
#@onready var player_icon : TextureRect = $"PlayerIcon"

#var update_dict = {
	#"walls": {
		#"up": true,
		#"right": true,
		#"down": true,
		#"left": true,
	#},
	#"icons": {
		#"player": true
	#}
#}

func make_map_json() -> void:
	# Create a json with the proper map information that must be later added to the
	# player progression object
	pass

func update_map_ui() -> void:
	var player_current_stage = PlayerData.player_progression["status"]["current_stage_id"]
	var player_current_chamber = PlayerData.player_progression["status"]["current_chamber_id"]
	var map_node_data = PlayerData.map_progression[player_current_stage][player_current_chamber]
	for child: MapNode in get_children():
		if(child.id == player_current_chamber):
			if(map_node_data.has("visited")):
				child.visited = map_node_data["visited"]
			if(map_node_data.has("walls")):
				child.up_open = map_node_data["walls"]["up"]
				child.right_open = map_node_data["walls"]["right"]
				child.down_open = map_node_data["walls"]["down"]
				child.left_open = map_node_data["walls"]["left"]
			child.player = true
		else:
			child.player = false	
