@tool
class_name ChamberTransition
extends Node2D

@onready var arrow_pivot: Node2D = $ArrowPivot

@export_enum("UP", "RIGHT", "DOWN", "LEFT", "NONE") var direction := "NONE":
	set(value):
		direction = value
		if not is_node_ready():
			await ready
		match value:
			"UP":
				arrow_pivot.rotation_degrees = 0
				arrow_pivot.show()
			"RIGHT": 
				arrow_pivot.rotation_degrees = 90
				arrow_pivot.show()
			"DOWN": 
				arrow_pivot.rotation_degrees = 180
				arrow_pivot.show()
			"LEFT":
				arrow_pivot.rotation_degrees = 270
				arrow_pivot.show()
			"NONE":
				arrow_pivot.hide()
			_:
				arrow_pivot.hide()
