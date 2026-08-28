@tool
extends Node2D
class_name BoxArea

@export var color := Color.RED 
@export var line_width := 2.0

@onready var top_left: Marker2D = $TopLeft
@onready var bottom_right: Marker2D = $BottomRight

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		queue_redraw()

func _draw() -> void:
	if(Engine.is_editor_hint()):
		draw_line(top_left.position, Vector2(bottom_right.position.x, top_left.position.y), color, line_width)
		draw_line(Vector2(bottom_right.position.x, top_left.position.y), bottom_right.position, color, line_width)
		draw_line(bottom_right.position, Vector2(top_left.position.x, bottom_right.position.y), color, line_width)
		draw_line(Vector2(top_left.position.x, bottom_right.position.y), top_left.position, color, line_width)

func sample_point() -> Vector2:
	var x_pos = randf_range(top_left.global_position.x, bottom_right.global_position.x)
	var y_pos = randf_range(top_left.global_position.y, bottom_right.global_position.y)
	return Vector2(x_pos, y_pos)
