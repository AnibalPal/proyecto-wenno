@tool
extends Node2D

@export var trigger_redraw := false:
	set(value):
		draw_jump_arc()
		trigger_redraw = false

@export var ticks := 5

var time_delta := 0.0
var points := []

func draw_jump_arc() -> void:
	time_delta = get_physics_process_delta_time()
	print(time_delta)
	if(Engine.is_editor_hint()):
		points.clear()
		var old_point := Vector2.ZERO
		var next_point := Vector2.ZERO
		var speed : int = owner.speed
		print(speed)
		var gravity : int = owner.gravity
		print(gravity)
		var jump_impulse : int = owner.jump_impulse
		print(jump_impulse)
		var velocity := Vector2(speed, -jump_impulse)
		for i in range(ticks):
			old_point = next_point
			velocity.y += gravity / 2.0 * time_delta
			next_point = Vector2(velocity.x * time_delta * i, velocity.y * time_delta * i)
			if(velocity.y < 0):
				points.append([old_point, next_point])
		queue_redraw()
		
func _draw() -> void:
	for point in points:
		draw_line(point[0], point[1], Color.RED, 4)
