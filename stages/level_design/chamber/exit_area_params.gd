@tool
class_name ChamberExit
extends Area2D

@export var next_chamber_path := ""
@export_tool_button("Open Scene")
var open_scene_button = editor_open_scene
@export var next_entry_name := ""

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		assert(next_chamber_path, "Exit " + name + ": No next chamber path set!")
		assert(next_entry_name, "Exit " + name + ": No next entry name set!")

func editor_open_scene() -> void:
	if(next_chamber_path):
		EditorInterface.open_scene_from_path(next_chamber_path)
