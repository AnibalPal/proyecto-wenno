@tool
class_name ChamberEntry
extends ChamberTransition

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		assert(direction, "Entrypoint %s: No direction set" % name)
