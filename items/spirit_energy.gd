extends Node2D
class_name SpiritEnergy

signal s_spirit_consumed

@export var max_points := 8
@export var speed := 100

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var line_2d: Line2D = $Line2D

var target : Node2D = null
var acceleration := 0.0

func _process(_delta: float) -> void:
	if(target):
		acceleration += _delta
		var direction = sprite_2d.global_position.direction_to(target.global_position)
		sprite_2d.global_position += direction * _delta * speed
		sprite_2d.global_position += direction * acceleration * 10
		line_2d.add_point(sprite_2d.global_position)
		if(len(line_2d.points) > max_points):
			line_2d.remove_point(0)
	else:
		line_2d.clear_points()

func set_start_position(new_pos : Vector2) -> void:
	sprite_2d.global_position = new_pos

func begin_move_to_target(new_target: Node2D) -> void:
	target = new_target

func _on_area_2d_area_entered(_area: Area2D) -> void:
	s_spirit_consumed.emit()
	queue_free()
