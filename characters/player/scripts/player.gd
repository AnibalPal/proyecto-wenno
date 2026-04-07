class_name Player
extends CharacterBody2D

@export var debug_mode := false

@export var speed := 100
@export var gravity := 300
@export var jump_impulse := 200

@onready var should_rotate := $"ShouldRotate"
@onready var floor_detection: RayCast2D = $ShouldNotRotate/FloorDetection

# Globar vars
var facing_right := true

# Utility functions to be used inside PlayerState scripts
func turn_around() -> void:
	facing_right = !facing_right
	should_rotate.transform.x = Vector2(-1, 0) 

func turn_right() -> void:
	if(facing_right): return
	facing_right = true
	should_rotate.transform.x = Vector2(1.0, 0.0)

func turn_left() -> void:
	if(!facing_right): return
	facing_right = false
	should_rotate.transform.x = Vector2(-1.0, 0.0)
	
func enable_gravity(_delta: float):
	velocity.y += gravity * _delta

func enable_x_movement():
	var x_direction = Input.get_axis("left", "right")
	if(x_direction > 0.1):
		turn_right()
	if(x_direction < -0.1):
		turn_left()	
	velocity.x = speed * x_direction
