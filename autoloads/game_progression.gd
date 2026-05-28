class_name GameProgression
extends Node

# This script should contain all things related to the player, like which map has he seen, what
# powerups does he have, max health, money, etc.

func save_game() -> void:
	pass

func load_game() -> void:
	pass

var player_progression := {
	# Main status and power ups
	"status": {
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
	"yastay": {
		"chamber_id_1": false
	}
}
