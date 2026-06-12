class_name Cutscene
extends Node2D

signal s_start_cutscene(cutscene_id: String)

@export var id := ""

func _on_trigger_area_entered(_area: Area2D) -> void:
	print("BEGIN CUTSCENE %s" % id)
	s_start_cutscene.emit(id)
