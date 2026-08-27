extends Node2D

@export var max_points := 8

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var line_2d: Line2D = $Line2D

var start_trail = false

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("click")):
		move_to_target(get_global_mouse_position())
	if(start_trail):
		line_2d.add_point(sprite_2d.global_position)
		if(len(line_2d.points) > max_points):
			line_2d.remove_point(0)
	else:
		line_2d.clear_points()

func move_to_target(target_pos: Vector2) -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(sprite_2d, "global_position", target_pos, 0.3)
	move_tween.finished.connect(on_move_finished)
	start_trail = true	

func on_move_finished() -> void:
	start_trail = false
