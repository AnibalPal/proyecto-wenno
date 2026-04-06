# Virtual State class, the functions here should be overriden in the proper state
class_name State
extends Node

signal s_finished

func enter(_data: Dictionary) -> void:
	return

func state_ready() -> void:
	return

func state_process(_delta: float) -> void:
	return

func state_physics_process(_delta: float) -> void:
	return
