class_name Cutscene
extends Node2D

signal s_start_cutscene(cutscene_id: String, cutscene_node: Cutscene)

@export var id := ""

@onready var entities: Node2D = $Entities

var current_idx := 0

# TODO: Change this to an export variable with resources
var cutscene_data := [
	[
		{
		"entity": "TestNPC",
		"action": Enums.CutsceneActions.SHOW,
		},
		{
		"entity": "player",
		"action": Enums.CutsceneActions.MOVE,
		"data": {
			"x": 100,
			"y": 100,
			}
		},
		{
		"entity": "TestNPC",
		"action": Enums.CutsceneActions.MOVE,
		"data": {
			"x": 450,
			"y": 100,
			}
		},
	],
	[
		{
			"entity": "TestNPC",
			"action": Enums.CutsceneActions.TALK,
			"data": {
				"text": "Hola",
			}
		}
	],
	[
		{
			"entity": "TestNPC",
			"action": Enums.CutsceneActions.MOVE,
			"data": {
				"x": 800,
				"y": 100,
			}
		}
	]
]

func _on_trigger_area_entered(_area: Area2D) -> void:
	s_start_cutscene.emit(id, self)

# Returns Dictionary or null
func get_next() -> Variant:
	var step_data
	if(current_idx < len(cutscene_data)):
		step_data = cutscene_data[current_idx]
		current_idx += 1
	else:
		step_data = null
		current_idx = 0
	return step_data

func execute(entity_name, action, data) -> void:
	var entity = entities.get_node_or_null(entity_name)
	assert(entity, "ENTITY NOT FOUND")
	entity.handle_action(action, data)
