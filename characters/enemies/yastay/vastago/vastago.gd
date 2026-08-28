@tool
class_name Vastago
extends Enemy

@onready var floor_detection: RayCast2D = $ShouldRotate/Raycasts/FloorDetection
@onready var wall_detection: RayCast2D = $ShouldRotate/Raycasts/WallDetection

@export var min_stop_time_secs := 0.2
@export var max_stop_time_secs := 1.0

@export var min_move_time_secs := 1.0
@export var max_move_time_secs := 1.5

@export var clash_strength := 1

var floor_colliding := false
var wall_colliding := false

var player_ref : Player = null

func character_ready() -> void:
	sprite_animations.play("idle")

func _physics_process(_delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(floor_detection.is_colliding()):
			floor_colliding = true
		else:
			floor_colliding = false
		
		if(wall_detection.is_colliding()):
			wall_colliding = true
		else:
			wall_colliding = false

func on_clash(_other_collision_position: Vector2) -> void:
	GlobalVFXs.hitstop()
	state_machine.transition_to_next_state(state_machine.CLASH, {
		"player_position": _other_collision_position
	})

func death():
	state_machine.transition_to_next_state(state_machine.DEATH)

func is_floor_colliding() -> bool:
	return floor_colliding	

func is_wall_colliding() -> bool:
	return wall_colliding
