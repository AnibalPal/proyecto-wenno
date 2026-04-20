# Virtual State class, the functions here should be overriden in the proper state
class_name State
extends Node

signal s_finished

@export var active := true:
	set(value):
		active = value
		update_configuration_warnings()

func _get_configuration_warnings():
	if !active:
		return ["This node is inactive"]
	else:
		return []


func enter(_data: Dictionary) -> void:
	return

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	return

# Wrapper for the s_finished signal emit
func transition_to(state_name: String, data = {}) -> void:
	s_finished.emit(state_name, data)
