class_name Cutscene
extends Node2D

signal s_start_cutscene(cutscene_id: String, cutscene_node: Cutscene)
signal s_step_complete

@export var id := ""

@onready var entities: Node2D = $Entities

var current_idx := 0
var action_stack := []
var expected_actions := 0

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
				"text": "Hola, Estoy probando el sistema de cutscenes",
				"width": 240
			}
		}
	],
	[
		{
			"entity": "TestNPC",
			"action": Enums.CutsceneActions.TALK,
			"data": {
				"text": "Texto pequeño",
				"width": 120
			}
		}
	],
	[
		{
			"entity": "TestNPC",
			"action": Enums.CutsceneActions.TALK,
			"data": {
				"text": "Ahora un texto mas largo a ver si se ve mas o menos decente, bla bla la la la",
				"width": 300
			}
		}
	],
	[
		{
			"entity": "TestNPC",
			"action": Enums.CutsceneActions.TALK,
			"data": {
				"text": "Bueno chao",
				"width": 100
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

func _ready() -> void:
	for cutscene_entity: CutsceneEntityBase in entities.get_children():
		cutscene_entity.s_action_complete.connect(on_action_complete)

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

func add_step_action(action_data := {}) -> void:
	action_stack.append(action_data)

func execute() -> void:
	expected_actions = len(action_stack)
	for action_data in action_stack:
		var entity = entities.get_node_or_null(action_data["entity"])
		assert(entity, "ENTITY NOT FOUND")
		var action_extra_data = action_data["data"] if action_data.has("data") else {}
		entity.handle_action(action_data["action"], action_extra_data)
	action_stack = []

func on_action_complete() -> void:
	expected_actions -= 1
	if(expected_actions <= 0):
		expected_actions = 0
		s_step_complete.emit()
