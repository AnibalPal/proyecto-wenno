class_name CutsceneState
extends Node

@onready var cutscene_state_manager := $".."
var cutscene_entity: CharacterEntity

func _ready() -> void:
	await owner.ready
	cutscene_entity = owner

func cutscene_state_enter(_data := {}) -> void:
	pass

func cutscene_state_process() -> void:
	pass

func cutscene_state_physics_process() -> void:
	pass
