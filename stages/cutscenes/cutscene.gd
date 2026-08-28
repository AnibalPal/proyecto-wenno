class_name Cutscene
extends Node2D

@onready var enemies: Node2D = $"../../Enemies"

signal s_start_cutscene(cutscene_id: String, cutscene_node: Cutscene)
signal s_step_complete

@export var id := ""
@export var cutscene_data : Array[CutsceneStep]

@onready var entities: Node2D = $Entities

var current_idx := 0
var action_stack :Array[CutsceneAction] = []
var expected_actions := 0
# Holds enemies or npcs that will still be in the game after the cutscene is done
var persisting_nodes = []

func _ready() -> void:
	if(PlayerData.player_progression["cutscenes"].has(id) and PlayerData.player_progression["cutscenes"][id]):
		queue_free()
	for cutscene_entity in entities.get_children():
		if(cutscene_entity is NPCBase or cutscene_entity is Enemy):
			cutscene_entity.enter_cutscene_mode()
			cutscene_entity.cutscene_state_machine.s_action_complete.connect(on_action_complete)
			cutscene_entity.cutscene_state_machine.s_persist.connect(on_persist)

func _on_trigger_area_entered(_area: Area2D) -> void:
	if(id):
		s_start_cutscene.emit(id, self)
	else:
		print("NO CUTSCENE ID SET")
		queue_free()

# Returns Dictionary or null
func get_next() -> Variant:
	var step_data
	if(current_idx < len(cutscene_data)):
		step_data = cutscene_data[current_idx]
		current_idx += 1
	else:
		step_data = null
		current_idx = 0
		action_stack = []
		expected_actions = 0
	return step_data

func add_step_action(action_data : CutsceneAction) -> void:
	action_stack.append(action_data)

func execute() -> void:
	expected_actions = len(action_stack)
	for action in action_stack:
		var entity = entities.get_node_or_null(action.entity)
		assert(entity, "ENTITY NOT FOUND")
		if(entity is NPCBase or entity is Enemy):
			if(entity.cutscene_state_machine.process_active):
				entity.cutscene_state_machine.execute_cutscene_step(action.action, action.data)
			else:
				print("Not in cutscene state, the state is: %s" % entity.state_machine.current_state.name)
	action_stack = []

func on_action_complete() -> void:
	expected_actions -= 1
	if(expected_actions <= 0):
		expected_actions = 0
		s_step_complete.emit()

func on_persist(node: Node) -> void:
	persisting_nodes.append(node)

func cutscene_complete() -> void:
	# Do some cleaning if needed, also instantiate nodes that should persist the cutscene, like summoned enemies
	for node: Node in persisting_nodes:
		#TODO: this assumes only enemies can persist, when NPCs are added this should
		# check that case as well
		node.exit_cutscene_mode()
		node.reparent(enemies)
	queue_free()
