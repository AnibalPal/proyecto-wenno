@tool
class_name EditorIconTool
extends Sprite2D

# Used to show an icon in the editor

@export var color := Color.BLUE

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		modulate = color

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		hide()	
