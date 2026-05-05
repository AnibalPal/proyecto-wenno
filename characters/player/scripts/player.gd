@tool
class_name Player
extends CharacterEntity

@export var speed := 100
@export var gravity := 300
@export var jump_impulse := 200

@onready var floor_detection: RayCast2D = $ShouldNotRotate/FloorDetection
@onready var player_animations: AnimatedSprite2D = $ShouldRotate/PlayerAnimations
@onready var hitboxes: Node2D = $ShouldRotate/Hitboxes

func enable_gravity(_delta: float):
	velocity.y += gravity * _delta

func enable_x_movement():
	var x_direction = Input.get_axis("left", "right")
	if(x_direction > 0.1):
		turn_right()
	if(x_direction < -0.1):
		turn_left()	
	velocity.x = speed * x_direction

func disable_hitboxes():
	for hitbox: PlayerHitBox in hitboxes.get_children():
		hitbox.disable()	
