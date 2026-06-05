extends Node

# This script should contain all things related to the player, like which map has he seen, what
# powerups does he have, max health, money, etc. I am also adding related global signals

var player_progression := {
	# Main status and power ups
	"status": {
		"current_stage_id": "",
		"current_chamber_id": "",
		"max_health": 5,
		"max_stamina": 5,
		"money": 0,
		"yastay_blessing": false
		# ...
	},
	"settings": {
		# ...
	}
}

var map_progression := {
	# the structure is as follows:
	#"stage_id": {
		# "selectable" : false, # is the stage selectable from the stage selection menu
		# "clear": false,
		# "chamber_id_1" : {
		# 	"visited": true,
		# 	"connections": ["right"] # Which sides to open in the map
		# }
		# "chamber_id_2" : {
		# 	"visited": false,
		# 	"connections": [] # Which sides to open in the map
		#   "power_up_1": false # Which powerups or collectibles have been obtained of the room
		#   "chest_1": false 
		# }
	# }
	"prototype": {
		"selectable": false,
		"clear": false,
		"1": {
			"visited": true
		},
		"2": {
			"visited": false
		},
		"3": {
			"visited": false
		},
		"4": {
			"visited": false
		},
		"5": {
			"visited": false
		},		
	},
	"yastay": {
		"chamber_id_1": false
	}
}

signal s_update_player_status(key: String, value: Variant)
signal s_update_map_progression(stage_id: String, chamber_id: String, key: String, value: Variant)

func _ready() -> void:
	# These will update the data dictionaries in order to then save/load, should have to connect
	# these signals for other functions to update UI for example
	s_update_map_progression.connect(on_update_map_progression)
	s_update_player_status.connect(on_update_player_satus)

func on_update_player_satus(key: String, value: Variant):
	if(player_progression["status"].has(key)):
		player_progression["status"][key] = value

func on_update_map_progression(stage_id: String, chamber_id: String, key: String, value: Variant):
	if(map_progression.has(stage_id)):
		var map_data = map_progression[stage_id]
		if(map_data.has(chamber_id)):
			var chamber_data = map_data[chamber_id]
			if(chamber_data.has(key)):
				chamber_data[key] = value

func save_game() -> void:
	pass

func load_game() -> void:
	pass
